{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, glib, gtk
, GConf, startupnotification, libXinerama, libXrandr, libXcursor
, gettext, intltool

, enableCompositor ? false
, libXcomposite ? null, libXfixes ? null, libXdamage ? null, libcm ? null
}:

assert enableCompositor ->
  libXcomposite != null && libXfixes != null && libXdamage != null && libcm != null;

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser glib gtk GConf startupnotification
    libXinerama libXrandr libXcursor gettext intltool
  ]
  ++ stdenv.lib.optionals enableCompositor [libXcomposite libXfixes libXdamage libcm];
  
  configureFlags = ''
    ${if enableCompositor then "--enable-compositor" else ""}
  '';
}
