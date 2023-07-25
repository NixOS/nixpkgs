## Template to generate config.mk via substitute-all

# set PREFIX externally
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
SRCDIR = $(PREFIX)/src
STDLIB = $(SRCDIR)/hare/stdlib

HAREPATH = $(SRCDIR)/hare/stdlib:$(SRCDIR)/hare/third-party

## Build configuration

# Platform to build for
PLATFORM = @platform@
ARCH = @arch@

# External tools and flags
HAREC = harec
HAREFLAGS = @hareflags@
QBE = qbe
AS = as
LD = ld
AR = ar
SCDOC = scdoc

# Where to store build artifacts
# set HARECACHE externally

# Cross-compiler toolchains
# # TODO: fixup this
AARCH64_AS=aarch64-as
AARCH64_AR=aarch64-ar
AARCH64_CC=aarch64-cc
AARCH64_LD=aarch64-ld

RISCV64_AS=riscv64-as
RISCV64_AR=riscv64-ar
RISCV64_CC=riscv64-cc
RISCV64_LD=riscv64-ld

X86_64_AS=as
X86_64_AR=ar
X86_64_CC=cc
X86_64_LD=ld
