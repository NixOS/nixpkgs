{ stdenv
, fetchurl
, pkgconfig
, meson
, ninja
, python3
, spice-protocol
, gettext
, openssl
, pixman
, gobject-introspection
, libjpeg_turbo
, zlib
, cyrus_sasl
, usbredir
, libsoup
, polkit
, acl
, usbutils
, vala
, gtk3
, epoxy
, libdrm
, gst_all_1
, phodav
, libopus
, gtk-doc
, json-glib
, lz4
, libcacard
, perl
, docbook_xsl
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
  version = "0.37";

  outputs = [ "out" "dev" "devdoc" "man" ];

  src = fetchurl {
    url = "https://www.spice-space.org/download/gtk/${pname}-${version}.tar.bz2";
    sha256 = "1drvj8y35gnxbnrxsipwi15yh0vs9ixzv4wslz6r3lra8w3bfa0z";
  };

  postPatch = ''
    # get rid of absolute path to helper in store so we can use a setuid wrapper
    substituteInPlace src/usb-acl-helper.c \
      --replace 'ACL_HELPER_PATH"/' '"'
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
    pkgconfig
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
    epoxy
    gtk3
    json-glib
    libcacard
    libdrm
    libjpeg_turbo
    lz4
    openssl
    libopus
    phodav
    pixman
    spice-protocol
    usbredir
    zlib
  ] ++ stdenv.lib.optionals withPolkit [ polkit acl usbutils ] ;

  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  mesonFlags = [
    "-Dcelt051=disabled"
    "-Dpulse=disabled" # is deprecated upstream
  ];

  meta = with stdenv.lib; {
    description = "GTK 3 SPICE widget";
    longDescription = ''
      spice-gtk is a GTK 3 SPICE widget. It features glib-based
      objects for SPICE protocol parsing and a gtk widget for embedding
      the SPICE display into other applications such as virt-manager.
      Python bindings are available too.
    '';

    homepage = https://www.spice-space.org/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.xeji ];
    platforms = platforms.linux;
  };
}
