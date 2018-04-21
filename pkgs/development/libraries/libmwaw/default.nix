{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.13";
    name="${baseName}-${version}";
    hash="1sjs3nc39im232h5bf81w3il8ivd7w2bc2qssxf7k74g8hlcfmfv";
    url="mirror://sourceforge/libmwaw/libmwaw/libmwaw-0.3.13/libmwaw-0.3.13.tar.xz";
    sha256="1sjs3nc39im232h5bf81w3il8ivd7w2bc2qssxf7k74g8hlcfmfv";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
