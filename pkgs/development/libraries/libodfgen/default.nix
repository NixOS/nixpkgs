{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libodfgen";
    version="0.1.4";
    name="${baseName}-${version}";
    hash="1qgilnsd57ayv9mqh4sg9mkknifr98dv70a35gizxh5cw7c5x6r4";
    url="mirror://sourceforge/project/libwpd/libodfgen/libodfgen-0.1.4/libodfgen-0.1.4.tar.xz";
    sha256="1qgilnsd57ayv9mqh4sg9mkknifr98dv70a35gizxh5cw7c5x6r4";
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
