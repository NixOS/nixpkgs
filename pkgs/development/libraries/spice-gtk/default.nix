{ stdenv, fetchurl, pkgconfig, spice-protocol, gettext, celt_0_5_1
, openssl, libpulseaudio, pixman, gobjectIntrospection, libjpeg_turbo, zlib
, cyrus_sasl, python2Packages, autoreconfHook, usbredir, libsoup
, polkit, acl, usbutils, vala
, gtk3, epoxy }:

with stdenv.lib;

let
  inherit (python2Packages) python pygtk;
in stdenv.mkDerivation rec {
  name = "spice-gtk-0.34";

  src = fetchurl {
    url = "http://www.spice-space.org/download/gtk/${name}.tar.bz2";
    sha256 = "1vknp72pl6v6nf3dphhwp29hk6gv787db2pmyg4m312z2q0hwwp9";
  };

  buildInputs = [
    spice-protocol celt_0_5_1 openssl libpulseaudio pixman gobjectIntrospection
    libjpeg_turbo zlib cyrus_sasl python pygtk usbredir gtk3 epoxy
    polkit acl usbutils
  ];

  nativeBuildInputs = [ pkgconfig gettext libsoup autoreconfHook vala ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  # put polkit action in the $out/share/polkit-1/actions
  preAutoreconf = ''
    substituteInPlace configure.ac \
      --replace 'POLICYDIR=`''${PKG_CONFIG} polkit-gobject-1 --variable=policydir`' "POLICYDIR=$out/share/polkit-1/actions"
  '';

  configureFlags = [
    "--with-gtk3"
  ];

  # usb redirection needs spice-client-glib-usb-acl-helper to run setuid root
  # the helper then uses polkit to check access
  # in nixos, enable this with
  # security.wrappers.spice-client-glib-usb-acl-helper.source =
  #   "${pkgs.spice_gtk}/bin/spice-client-glib-usb-acl-helper.real";
  postFixup = ''
    mv $out/bin/spice-client-glib-usb-acl-helper $out/bin/spice-client-glib-usb-acl-helper.real
    ln -sf /run/wrappers/bin/spice-client-glib-usb-acl-helper $out/bin/spice-client-glib-usb-acl-helper
  '';

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
