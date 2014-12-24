{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libodfgen";
    version="0.1.2";
    name="${baseName}-${version}";
    hash="05f0l90a715kw6n1hbq393alwyjipyp0dcqqqrwm2l0s4p151bpd";
    url="mirror://sourceforge/project/libwpd/libodfgen/libodfgen-0.1.2/libodfgen-0.1.2.tar.xz";
    sha256="05f0l90a715kw6n1hbq393alwyjipyp0dcqqqrwm2l0s4p151bpd";
  };
  buildInputs = [
    boost pkgconfig cppunit zlib libwpg libwpd librevenge
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
    description = ''A base library for generating ODF documents'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
