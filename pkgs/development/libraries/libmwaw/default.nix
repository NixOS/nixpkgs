{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.7";
    name="${baseName}-${version}";
    hash="1yg8zvv71r6wsrj71as1ngavj07527d8vrzdrf7s4yf2f7l12xh5";
    url="mirror://sourceforge/project/libmwaw/libmwaw/libmwaw-0.3.7/libmwaw-0.3.7.tar.xz";
    sha256="1yg8zvv71r6wsrj71as1ngavj07527d8vrzdrf7s4yf2f7l12xh5";
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
