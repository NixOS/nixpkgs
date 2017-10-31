{ stdenv, fetchurl, pkgconfig, spice_protocol, intltool, celt_0_5_1
, openssl, libpulseaudio, pixman, gobjectIntrospection, libjpeg_turbo, zlib
, cyrus_sasl, python2Packages, autoreconfHook, usbredir, libsoup
, gtk3, epoxy }:

with stdenv.lib;

let
  inherit (python2Packages) python pygtk;
in stdenv.mkDerivation rec {
  name = "spice-gtk-0.33";

  src = fetchurl {
    url = "http://www.spice-space.org/download/gtk/${name}.tar.bz2";
    sha256 = "0fdgx9k4vgmasp8i2n0swrkapq8f212igcg7wsgvr3mbhsvk7bvx";
  };

  buildInputs = [
    spice_protocol celt_0_5_1 openssl libpulseaudio pixman gobjectIntrospection
    libjpeg_turbo zlib cyrus_sasl python pygtk usbredir gtk3 epoxy
  ];

  nativeBuildInputs = [ pkgconfig intltool libsoup autoreconfHook ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  preAutoreconf = ''
    substituteInPlace src/Makefile.am \
          --replace '=codegendir pygtk-2.0' '=codegendir pygobject-2.0'
  '';

  preConfigure = ''
    intltoolize -f
  '';

  configureFlags = [
    "--disable-maintainer-mode"
    "--with-gtk3"
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

    platforms = platforms.linux;
  };
}
