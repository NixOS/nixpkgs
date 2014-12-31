{stdenv, fetchurl, boost, pkgconfig, cppunit, zlib}:
let
  s = # Generated upstream information
  rec {
    baseName="librevenge";
    version="0.0.2";
    name="${baseName}-${version}";
    hash="03ygxyb0vfjv8raif5q62sl33b54wkr5rzgadb8slijm6k281wpn";
    url="mirror://sourceforge/project/libwpd/librevenge/librevenge-0.0.2/librevenge-0.0.2.tar.xz";
    sha256="03ygxyb0vfjv8raif5q62sl33b54wkr5rzgadb8slijm6k281wpn";
  };
  buildInputs = [
    boost pkgconfig cppunit zlib
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
    description = ''A base library for writing document import filters'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
