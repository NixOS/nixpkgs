{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.16";
    name="${baseName}-${version}";
    hash="0s0qvrmxzs8wv4304p7zx9mrasglyaszafqrfmaxwyr9lpdrwqqc";
    url="mirror://sourceforge/libmwaw/libmwaw/libmwaw-0.3.16/libmwaw-0.3.16.tar.xz";
    sha256="0s0qvrmxzs8wv4304p7zx9mrasglyaszafqrfmaxwyr9lpdrwqqc";
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
