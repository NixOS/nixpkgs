{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.4";
    name="${baseName}-${version}";
    hash="1sn95flxrh85qjsg1kk700c1ggxaaccr9j1nnw7x4daw8lky25ac";
    url="mirror://sourceforge/project/libmwaw/libmwaw/libmwaw-0.3.4/libmwaw-0.3.4.tar.xz";
    sha256="1sn95flxrh85qjsg1kk700c1ggxaaccr9j1nnw7x4daw8lky25ac";
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
