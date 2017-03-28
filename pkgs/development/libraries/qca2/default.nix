{ stdenv, fetchurl, cmake, pkgconfig, qt }:

stdenv.mkDerivation rec {
  name = "qca-${version}";
  version = "2.1.3";

  src = fetchurl {
    url = "http://download.kde.org/stable/qca/${version}/src/qca-${version}.tar.xz";
    sha256 = "0lz3n652z208daxypdcxiybl0a9fnn6ida0q7fh5f42269mdhgq0";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qt ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.sander ];
    platforms = platforms.linux;
  };
}
