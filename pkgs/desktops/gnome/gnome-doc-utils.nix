{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, python
, libxml2, libxslt, gettext
}:

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser python
    libxml2 libxslt gettext
  ];

  configureFlags = "--disable-scrollkeeper";
}
