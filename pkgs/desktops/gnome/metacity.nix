{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, glib, gtk
, GConf, startupnotification, libXinerama, libXrandr, libXcursor
, gettext

, enableCompositor ? false
, libXcomposite ? null, libXfixes ? null, libXdamage ? null, libcm ? null
}:

assert enableCompositor ->
  libXcomposite != null && libXfixes != null && libXdamage != null && libcm != null;

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser glib gtk GConf startupnotification
    libXinerama libXrandr libXcursor gettext
  ]
  ++ (if enableCompositor then [libXcomposite libXfixes libXdamage libcm] else []);
  
  configureFlags = "
    ${if enableCompositor then "--enable-compositor" else ""}
  ";
}
