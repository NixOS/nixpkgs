{ stdenv, fetchurl, pkgconfig, gtk, spice_protocol, intltool, celt_0_5_1
, openssl, libpulseaudio, pixman, gobjectIntrospection, libjpeg_turbo, zlib
, cyrus_sasl, python, pygtk, autoreconfHook, usbredir, libsoup
, gtk3, enableGTK3 ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "spice-gtk-0.29";

  src = fetchurl {
    url = "http://www.spice-space.org/download/gtk/${name}.tar.bz2";
    sha256 = "0wz9sm44gnmwjpmyacwd5jyzvhfl1wlf1dn3qda20si42cky5is4";
  };

  buildInputs = [
    spice_protocol celt_0_5_1 openssl libpulseaudio pixman gobjectIntrospection
    libjpeg_turbo zlib cyrus_sasl python pygtk usbredir
  ] ++ (if enableGTK3 then [ gtk3 ] else [ gtk ]);

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
    (if enableGTK3 then "--with-gtk3" else "--with-gtk=2.0")
  ];

  dontDisableStatic = true; # Needed by the coroutine test

  enableParallelBuilding = true;

  meta = {
    description = "A GTK+2 and GTK+3 SPICE widget";
    longDescription = ''
      spice-gtk is a GTK+2 and GTK+3 SPICE widget. It features glib-based
      objects for SPICE protocol parsing and a gtk widget for embedding
      the SPICE display into other applications such as virt-manager.
      Python bindings are available too.
    '';

    homepage = http://www.spice-space.org/;
    license = licenses.lgpl21;

    platforms = platforms.linux;
  };
}
