{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.8";
    name="${baseName}-${version}";
    hash="019vk8cj3lgbrpgj48zy25mpkgmllwxznkfd94hh9vbb1cjvpz3a";
    url="mirror://sourceforge/project/libmwaw/libmwaw/libmwaw-0.3.8/libmwaw-0.3.8.tar.xz";
    sha256="019vk8cj3lgbrpgj48zy25mpkgmllwxznkfd94hh9vbb1cjvpz3a";
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
