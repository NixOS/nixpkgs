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
