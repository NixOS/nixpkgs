{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, glib, gtk
, GConf, startupnotification, libXinerama, libXrandr, libXcursor
, gettext
}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [
    pkgconfig perl perlXMLParser glib gtk GConf startupnotification
    libXinerama libXrandr libXcursor gettext
  ];
  #configureFlags = "--disable-gconf";
}
