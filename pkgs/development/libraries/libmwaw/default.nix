{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib, libwpg, libwpd, librevenge}:
let
  s = # Generated upstream information
  rec {
    baseName="libmwaw";
    version="0.3.10";
    name="${baseName}-${version}";
    hash="087j6kx03ggvqwpl944nnf75qkvi9bag8b0z59phg66gbz0s0imj";
    url="https://netcologne.dl.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.10/libmwaw-0.3.10.tar.xz";
    sha256="087j6kx03ggvqwpl944nnf75qkvi9bag8b0z59phg66gbz0s0imj";
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
