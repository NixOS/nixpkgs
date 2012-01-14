{ stdenv, fetchurl, pkgconfig, gtk, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, gstreamer, gstPluginsBase, GConf
, mesa, compat24 ? false, compat26 ? true, unicode ? true,
}:

stdenv.mkDerivation {
  name = "wxGTK-2.8.12";

  src = fetchurl {
    url = mirror://sourceforge/wxwindows/wxGTK-2.8.12.tar.gz;
    sha256 = "1gjs9vfga60mk4j4ngiwsk9h6c7j22pw26m3asxr1jwvqbr8kkqk";
  };

  buildInputs = [ gtk libXinerama libSM libXxf86vm xf86vidmodeproto mesa gstreamer gstPluginsBase GConf ];

  buildNativeInputs = [ pkgconfig ];

  configureFlags = [
    "--enable-gtk2"
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
    "--disable-precomp-headers"
    (if unicode then "--enable-unicode" else "")
    "--with-opengl"
    "--enable-mediactrl"
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

  enableParallelBuilding = true;
}
