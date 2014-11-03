{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libodfgen";
    version="0.1.1";
    name="${baseName}-${version}";
    hash="1p335m2l19c7glsss30rrm5dxfcyajk9fvj7rsclgn0kmb4y48cm";
    url="mirror://sourceforge/project/libwpd/libodfgen/libodfgen-0.1.1/libodfgen-0.1.1.tar.xz";
    sha256="1p335m2l19c7glsss30rrm5dxfcyajk9fvj7rsclgn0kmb4y48cm";
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
