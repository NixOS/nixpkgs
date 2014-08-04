{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.1";
    name="${baseName}-${version}";
    hash="0fa6nf4pxl853xnh2kdjw1nk3w6i39diixiampml7g9qygbd0vqb";
    url="mirror://sourceforge/project/libmwaw/libmwaw/libmwaw-0.3.1/libmwaw-0.3.1.tar.xz";
    sha256="0fa6nf4pxl853xnh2kdjw1nk3w6i39diixiampml7g9qygbd0vqb";
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
