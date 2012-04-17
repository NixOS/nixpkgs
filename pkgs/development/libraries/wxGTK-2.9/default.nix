{ stdenv, fetchurl, pkgconfig, gtk, libXinerama, libSM, libXxf86vm, xf86vidmodeproto
, gstreamer, gst_plugins_base, GConf
, withMesa ? true, mesa ? null, compat24 ? false, compat26 ? true, unicode ? true,
}:

assert withMesa -> mesa != null;

with stdenv.lib;

stdenv.mkDerivation {
  name = "wxwidgets-2.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/wxwindows/wxWidgets-2.9.3.tar.bz2";
    sha256 = "739c31a360b5c46b55904a7fb086f5cdfff0816efbc491d8263349210bf323b2";
  };

  buildInputs = [ gtk libXinerama libSM libXxf86vm xf86vidmodeproto gstreamer gst_plugins_base GConf ]
    ++ optional withMesa mesa;

  buildNativeInputs = [ pkgconfig ];

  configureFlags = [
    "--enable-gtk2"
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
    "--disable-precomp-headers"
    (if unicode then "--enable-unicode" else "")
    "--enable-mediactrl"
  ] ++ optional withMesa "--with-opengl";

  SEARCH_LIB = optionalString withMesa "${mesa}/lib";

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
