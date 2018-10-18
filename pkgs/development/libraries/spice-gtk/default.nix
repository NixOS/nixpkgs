{ stdenv, fetchurl, pkgconfig, spice-protocol, gettext, celt_0_5_1
, openssl, libpulseaudio, pixman, gobjectIntrospection, libjpeg_turbo, zlib
, cyrus_sasl, python2Packages, autoreconfHook, usbredir, libsoup
, withPolkit ? true, polkit, acl, usbutils
, vala, gtk3, epoxy, libdrm, gst_all_1, phodav, opusfile }:

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

with stdenv.lib;

let
  inherit (python2Packages) python pygtk;
in stdenv.mkDerivation rec {
  name = "spice-gtk-0.35";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.spice-space.org/download/gtk/${name}.tar.bz2";
    sha256 = "11lymg467gvj5ys8k22ihnfbxjn4x34ygyzirpg2nphjwlyhgrml";
  };

  postPatch = ''
    # get rid of absolute path to helper in store so we can use a setuid wrapper
    substituteInPlace src/usb-acl-helper.c \
      --replace 'ACL_HELPER_PATH"/' '"'
  '';

  buildInputs = [
    spice-protocol celt_0_5_1 openssl libpulseaudio gst_all_1.gst-plugins-base pixman
    libjpeg_turbo zlib cyrus_sasl python pygtk usbredir gtk3 epoxy libdrm phodav opusfile
  ] ++ optionals withPolkit [ polkit acl usbutils ] ;

  nativeBuildInputs = [ pkgconfig gettext libsoup autoreconfHook vala gobjectIntrospection ];

  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "$(out)/share/polkit-1/actions";

  configureFlags = [
    "--with-gtk3"
    "--enable-introspection"
    "--enable-vala"
    "--enable-celt051"
  ];

  dontDisableStatic = true; # Needed by the coroutine test

  enableParallelBuilding = true;

  meta = {
    description = "A GTK+3 SPICE widget";
    longDescription = ''
      spice-gtk is a GTK+3 SPICE widget. It features glib-based
      objects for SPICE protocol parsing and a gtk widget for embedding
      the SPICE display into other applications such as virt-manager.
      Python bindings are available too.
    '';

    homepage = http://www.spice-space.org/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.xeji ];
    platforms = platforms.linux;
  };
}
