{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.14";
    name="${baseName}-${version}";
    hash="1s9wyf8pyh3fbazq2d2b6fgi7s7bid60viw2xbdkmn2ywlfbza5c";
    url="mirror://sourceforge/libmwaw/libmwaw/libmwaw-0.3.14/libmwaw-0.3.14.tar.xz";
    sha256="1s9wyf8pyh3fbazq2d2b6fgi7s7bid60viw2xbdkmn2ywlfbza5c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost cppunit zlib libwpg libwpd librevenge
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit nativeBuildInputs buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''Import library for some old mac text documents'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
