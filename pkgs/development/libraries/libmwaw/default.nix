{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.9";
    name="${baseName}-${version}";
    hash="185jnp7b7s550xpz3bhaii275qw5yd3j29zijkd2rr8h2p9s9z7p";
    url="https://heanet.dl.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.9/libmwaw-0.3.9.tar.xz";
    sha256="185jnp7b7s550xpz3bhaii275qw5yd3j29zijkd2rr8h2p9s9z7p";
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
