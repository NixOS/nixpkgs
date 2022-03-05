{ lib, stdenv
, fetchurl
, acl
, cyrus_sasl
, docbook_xsl
, libepoxy
, gettext
, gobject-introspection
, gst_all_1
, gtk-doc
, gtk3
, hwdata
, json-glib
, libcacard
, libcap_ng
, libdrm
, libjpeg_turbo
, libopus
, libsoup
, libusb1
, lz4
, meson
, ninja
, openssl
, perl
, phodav
, pixman
, pkg-config
, polkit
, python3
, spice-protocol
, usbredir
, vala
, wayland-protocols
, zlib
, withPolkit ? true
}:

# If this package is built with polkit support (withPolkit=true),
# usb redirection reqires spice-client-glib-usb-acl-helper to run setuid root.
# The helper confirms via polkit that the user has an active session,
# then adds a device acl entry for that user.
# Example NixOS config to create a setuid wrapper for the helper:
# security.wrappers.spice-client-glib-usb-acl-helper.source =
#   "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
# On non-NixOS installations, make a setuid copy of the helper
# outside the store and adjust PATH to find the setuid version.

# If this package is built without polkit support (withPolkit=false),
# usb redirection requires read-write access to usb devices.
# This can be granted by adding users to a custom group like "usb"
# and using a udev rule to put all usb devices in that group.
# Example NixOS config:
#  users.groups.usb = {};
#  users.users.dummy.extraGroups = [ "usb" ];
#  services.udev.extraRules = ''
#    KERNEL=="*", SUBSYSTEMS=="usb", MODE="0664", GROUP="usb"
#  '';

stdenv.mkDerivation rec {
  pname = "spice-gtk";
  version = "0.40";

  outputs = [ "out" "dev" "devdoc" "man" ];

  src = fetchurl {
    url = "https://www.spice-space.org/download/gtk/${pname}-${version}.tar.xz";
    sha256 = "sha256-I/X/f6gLdWR85zzaXq+LMi80Mtu7f286g5Y0YYrbztM=";
  };

  postPatch = ''
    # get rid of absolute path to helper in store so we can use a setuid wrapper
    substituteInPlace src/usb-acl-helper.c \
      --replace 'ACL_HELPER_PATH"/' '"'
    # don't try to setcap/suid in a nix builder
    substituteInPlace src/meson.build \
      --replace "meson.add_install_script('../build-aux/setcap-or-suid'," \
      "# meson.add_install_script('../build-aux/setcap-or-suid',"
  '';

  nativeBuildInputs = [
    docbook_xsl
    gettext
    gobject-introspection
    gtk-doc
    libsoup
    meson
    ninja
    perl
    pkg-config
    python3
    python3.pkgs.pyparsing
    python3.pkgs.six
    vala
  ];

  propagatedBuildInputs = [
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
  ];

  buildInputs = [
    cyrus_sasl
    libepoxy
    gtk3
    json-glib
    libcacard
    libcap_ng
    libdrm
    libjpeg_turbo
    libopus
    libusb1
    lz4
    openssl
    phodav
    pixman
    spice-protocol
    usbredir
    wayland-protocols
    zlib
  ] ++ lib.optionals withPolkit [ polkit acl ] ;

  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  mesonFlags = [
    "-Dusb-acl-helper-dir=${placeholder "out"}/bin"
    "-Dusb-ids-path=${hwdata}/share/hwdata/usb.ids"
  ] ++ lib.optionals (!withPolkit) [
    "-Dpolkit=disabled"
  ];

  meta = with lib; {
    description = "GTK 3 SPICE widget";
    longDescription = ''
      spice-gtk is a GTK 3 SPICE widget. It features glib-based
      objects for SPICE protocol parsing and a gtk widget for embedding
      the SPICE display into other applications such as virt-manager.
      Python bindings are available too.
    '';

    homepage = "https://www.spice-space.org/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.xeji ];
    platforms = platforms.linux;
  };
}
