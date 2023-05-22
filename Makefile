SHELL := bash

export CAPNP_INCLUDE_PATH = $(abspath $(dir $(shell which capnp))/../include)
#export CCACHE = $(shell which ccache)
export CXX = $(shell which g++)
export CXXFLAGS+=-DCAPNP_INCLUDE_PATH=$(CAPNP_INCLUDE_PATH)
export CXXFLAGS+=-ggdb --std=c++20

export LIBS = \
  -lsystemd \
  -lcapnpc -lcapnp-rpc -lcapnp \
  -lcapnp-json \
  -lkj-async -lkj-gzip -lkj \
  -lkj-test \
  -lpthread \
  -lz \
  -lgtest_main -lgtest

NIX_BUILD_CORES ?= 7
EKAM := env \
    LC_ALL=C \
    EKAM_REMAP_BYPASS_DIRS=$(HOME)/.cache/ \
  nice ekam

EKAM_FLAGS := -j $(NIX_BUILD_CORES)

.DEFAULT: release

debug continuous: export CXXFLAGS+=-O0
release release-continuous: export CXXFLAGS+=-O2 -DNDEBUG

debug-continuous release-continuous: export EKAM_FLAGS+=-c

debug debug-continuous release release-continuous:
	$(EKAM) $(EKAM_FLAGS)

clean:
	rm -fr bin tmp

.PHONY: clean all
