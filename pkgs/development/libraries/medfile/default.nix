{ stdenv, fetchurl, cmake, hdf5 }:

stdenv.mkDerivation rec {
  name = "medfile-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "http://files.salome-platform.org/Salome/other/med-${version}.tar.gz";
    sha256 = "017h9p0x533fm4gn6pwc8kmp72rvqmcn6vznx72nkkl2b05yjx54";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ hdf5 ];

  checkPhase = "make test";

  postInstall = "rm -r $out/bin/testc";

  meta = with stdenv.lib; {
    description = "Library to read and write MED files";
    homepage = http://salome-platform.org/;
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
