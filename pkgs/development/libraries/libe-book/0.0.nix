{stdenv, fetchurl, gperf, pkgconfig, librevenge, libxml2, boost, icu, cppunit
, libwpd}:
let
  s = # Generated upstream information
  rec {
    baseName="libe-book";
    version="0.0.3";
    name="${baseName}-${version}";
    hash="06xhg319wbqrkj8914npasv5lr7k2904mmy7wa78063mkh31365i";
    url="mirror://sourceforge/project/libebook/libe-book-0.0.3/libe-book-0.0.3.tar.xz";
    sha256="06xhg319wbqrkj8914npasv5lr7k2904mmy7wa78063mkh31365i";
  };
  buildInputs = [
    gperf pkgconfig librevenge libxml2 boost icu cppunit libwpd
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''Library for import of reflowable e-book formats'';
    license = stdenv.lib.licenses.lgpl21Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
