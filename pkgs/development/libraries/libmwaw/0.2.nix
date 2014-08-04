{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.2.1";
    name="${baseName}-${version}";
    hash="1fil1ll84pq0k3g6rcc2xfg1yrigkljp4ay5p2wpwd9qlmfvvvqn";
    url="mirror://sourceforge/project/libmwaw/libmwaw/libmwaw-0.2.1/libmwaw-0.2.1.tar.xz";
    sha256="1fil1ll84pq0k3g6rcc2xfg1yrigkljp4ay5p2wpwd9qlmfvvvqn";
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
