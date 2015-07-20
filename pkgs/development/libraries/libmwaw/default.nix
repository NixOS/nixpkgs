{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.5";
    name="${baseName}-${version}";
    hash="1vx9h419fcfcs0yj071hsg9d2qvkacgca6052m8hv3h743cdmzil";
    url="mirror://sourceforge/project/libmwaw/libmwaw/libmwaw-0.3.5/libmwaw-0.3.5.tar.xz";
    sha256="1vx9h419fcfcs0yj071hsg9d2qvkacgca6052m8hv3h743cdmzil";
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
