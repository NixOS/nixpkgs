{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, python
, libxml2, libxslt, gettext
}:

# !!! xml2po needs to store the path to libxml2

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser python
    libxml2 libxslt gettext
  ];

  configureFlags = "--disable-scrollkeeper";
}
