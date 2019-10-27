# This Makefile is used by mx to bootstrap libffi build.

# `make MX_VERBOSE=y` will report all lines executed. The actual value doesn't
# matter as long as it's not empty.
QUIETLY$(MX_VERBOSE) = @

.PHONY: default

default:
	$(QUIETLY) echo CONFIGURE libffi
	$(QUIETLY) mkdir ../$(OUTPUT)
	$(QUIETLY) cd ../$(OUTPUT) && ../$(SOURCES)/configure $(CONFIGURE_ARGS) > ../libffi.configure.log
	$(QUIETLY) echo MAKE libffi
	$(QUIETLY) $(MAKE) -C ../$(OUTPUT) > ../libffi.build.log
