{ stdenv, fetchurl, pkgconfig, gtk, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, mesa, compat24 ? false, compat26 ? true, unicode ? true,
}:

assert pkgconfig != null && gtk != null;
assert gtk.libtiff != null;
assert gtk.libjpeg != null;
assert gtk.libpng != null;
assert gtk.libpng.zlib != null;

stdenv.mkDerivation {
  name = "wxGTK-2.8.11";

  src = fetchurl {
    url = mirror://sourceforge/wxwindows/wxGTK-2.8.11.tar.gz;
    sha256 = "149waiwwzw238avkhj8vmm1394nw45fa02b7cf1mqwc3jdd1pfz6";
  };

  buildInputs = [
    pkgconfig gtk gtk.libtiff gtk.libjpeg gtk.libpng gtk.libpng.zlib
    libXinerama libSM libXxf86vm xf86vidmodeproto mesa
  ];

  configureFlags = [
    "--enable-gtk2"
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
    "--disable-precomp-headers"
    (if unicode then "--enable-unicode" else "")
    "--with-opengl"
  ];

  # This variable is used by configure to find some dependencies.
  SEARCH_INCLUDE =
    "${libXinerama}/include ${libSM}/include ${libXxf86vm}/include";

  SEARCH_LIB = "${mesa}/lib";

  # Work around a bug in configure.
  NIX_CFLAGS_COMPILE = "-DHAVE_X11_XLIB_H=1";

  preConfigure = "
    substituteInPlace configure --replace 'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace 'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace /usr /no-such-path
  ";

  postBuild = "(cd contrib/src && make)";
  postInstall = "
    (cd contrib/src && make install)
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {inherit gtk compat24 compat26 unicode;};
}
