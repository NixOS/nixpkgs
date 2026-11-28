DESTDIR ?= /usr
BINDIR ?= $(DESTDIR)/bin
UDEVDIR ?= $(DESTDIR)/lib/udev/rules.d
UNITDIR ?= $(DESTDIR)/lib/systemd/system
CARGO_RELEASE_DIR ?= target/release
LOSETUP_BIN ?= $(BINDIR)/losetup

all:
	cargo build --release

install:
	install -dDm0755 $(BINDIR)
	install -pm0755 $(CARGO_RELEASE_DIR)/ventoy-compat-protocol $(BINDIR)/ventoy-compat-protocol
	ln -s ventoy-compat-protocol $(BINDIR)/ventoy-compat-protocol-generator
	install -dDm0755 $(UDEVDIR)
	install -pm0644 70-ventoy.rules.in $(UDEVDIR)/70-ventoy.rules
	sed -i "s|@ventoy-compat-protocol@|$(BINDIR)/ventoy-compat-protocol|" $(UDEVDIR)/70-ventoy.rules
	install -dDm0755 $(UNITDIR)
	install -pm0644 ventoy-losetup@.service.in $(UNITDIR)/ventoy-losetup@.service
	sed -i "s|@LOSETUP_BIN@|$(LOSETUP_BIN)|" $(UNITDIR)/ventoy-losetup@.service
	install -pm0644 ventoy-detect-hook.service.in $(UNITDIR)/ventoy-detect-hook.service
	sed -i "s|@ventoy-compat-protocol@|$(BINDIR)/ventoy-compat-protocol|" $(UNITDIR)/ventoy-detect-hook.service
	install -pm0644 run-ventoy.mount $(UNITDIR)/run-ventoy.mount
