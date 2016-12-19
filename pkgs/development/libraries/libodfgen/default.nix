{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libodfgen";
    version="0.1.6";
    name="${baseName}-${version}";
    hash="1sdr42f0bigip14zhs51m0zdwwzzl1mwmk882l4khpph8jmi1ch3";
    url="mirror://sourceforge/project/libwpd/libodfgen/libodfgen-0.1.6/libodfgen-0.1.6.tar.xz";
    sha256="1sdr42f0bigip14zhs51m0zdwwzzl1mwmk882l4khpph8jmi1ch3";
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
