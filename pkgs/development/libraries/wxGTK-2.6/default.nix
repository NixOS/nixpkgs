{ stdenv, fetchurl, pkgconfig, gtk, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, compat22 ? false, compat24 ? true, unicode ? true
}:

stdenv.mkDerivation {
  name = "wxGTK-2.6.4";

  src = fetchurl {
    url = mirror://sourceforge/wxwindows/wxGTK-2.6.4.tar.gz;
    sha256 = "1yilzg9qxvdpqhhd3sby1w9pj00k7jqw0ikmwyhh5jmaqnnnrb2x";
  };

  buildInputs = [ gtk libXinerama libSM libXxf86vm xf86vidmodeproto ];

  buildNativeInputs = [ pkgconfig ];

  configureFlags = [
    "--enable-gtk2"
    (if compat22 then "--enable-compat22" else "--disable-compat22")
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    "--disable-precomp-headers"
    (if unicode then "--enable-unicode" else "")
  ];

  # This variable is used by configure to find some dependencies.
  SEARCH_INCLUDE =
    "${libXinerama}/include ${libSM}/include ${libXxf86vm}/include";

  # Work around a bug in configure.
  NIX_CFLAGS_COMPILE = "-DHAVE_X11_XLIB_H=1";

  preConfigure = "
    substituteInPlace configure --replace 'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace /usr /no-such-path
  ";

  postBuild = "(cd contrib/src && make)";
  postInstall = "
    (cd contrib/src && make install)
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {inherit gtk compat22 compat24 unicode;};
}
