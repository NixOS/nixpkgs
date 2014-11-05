{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.3";
    name="${baseName}-${version}";
    hash="0dqwrswqmdhbj7gxsivvnwnsly181x27a5zq9fpizk82cnx2s8ks";
    url="mirror://sourceforge/project/libmwaw/libmwaw/libmwaw-0.3.3/libmwaw-0.3.3.tar.xz";
    sha256="0dqwrswqmdhbj7gxsivvnwnsly181x27a5zq9fpizk82cnx2s8ks";
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
    description = ''Import library for some old mac text documents'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
