{stdenv, fetchurl, gperf, pkgconfig, librevenge, libxml2, boost, icu, cppunit}:
let
  s = # Generated upstream information
  rec {
    baseName="libe-book";
    version="0.1.1";
    name="${baseName}-${version}";
    hash="0awv96q92qgxk22w2vrf4vg90cab5qfsrkbhgz252722mrkd5p4a";
    url="mirror://sourceforge/project/libebook/libe-book-0.1.1/libe-book-0.1.1.tar.xz";
    sha256="0awv96q92qgxk22w2vrf4vg90cab5qfsrkbhgz252722mrkd5p4a";
  };
  buildInputs = [
    gperf pkgconfig librevenge libxml2 boost icu cppunit
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
