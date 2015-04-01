{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libodfgen";
    version="0.1.3";
    name="${baseName}-${version}";
    hash="1flfh1i4r116aqdlqpgpmyzpcylwba48l7mddj25a2cwgsc9v86k";
    url="mirror://sourceforge/project/libwpd/libodfgen/libodfgen-0.1.3/libodfgen-0.1.3.tar.xz";
    sha256="1flfh1i4r116aqdlqpgpmyzpcylwba48l7mddj25a2cwgsc9v86k";
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
