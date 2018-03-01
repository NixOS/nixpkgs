{ stdenv, fetchurl, pkgconfig, spice-protocol, gettext, celt_0_5_1
, openssl, libpulseaudio, pixman, gobjectIntrospection, libjpeg_turbo, zlib
, cyrus_sasl, python2Packages, autoreconfHook, usbredir, libsoup
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
  ];

  nativeBuildInputs = [ pkgconfig gettext libsoup autoreconfHook ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  preAutoreconf = ''
    substituteInPlace src/Makefile.am \
          --replace '=codegendir pygtk-2.0' '=codegendir pygobject-2.0'
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
