{ stdenv, fetchurl, pkgconfig, gtk, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, gstreamer, gstPluginsBase, GConf
, mesa, compat24 ? false, compat26 ? true, unicode ? true,
}:

stdenv.mkDerivation {
  name = "wxwidgets-2.9.0";

  src = fetchurl {
    url = mirror://sourceforge/wxwindows/wxWidgets-2.9.0.tar.bz2;
    sha256 = "10n75mpypd9411b29gxmi0g2s7dgbfwkgiyhxwkjsyrmyvfc3xcc";
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

  SEARCH_LIB = "${mesa}/lib";

  preConfigure = "
    substituteInPlace configure --replace 'SEARCH_INCLUDE=' 'DUMMY_SEARCH_INCLUDE='
    substituteInPlace configure --replace 'SEARCH_LIB=' 'DUMMY_SEARCH_LIB='
    substituteInPlace configure --replace /usr /no-such-path
  ";

  postInstall = "
    (cd $out/include && ln -s wx-*/* .)
  ";

  passthru = {inherit gtk compat24 compat26 unicode;};

  enableParallelBuilding = true;
}
