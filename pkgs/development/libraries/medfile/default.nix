{ stdenv, fetchurl, cmake, hdf5 }:

stdenv.mkDerivation rec {
  name = "medfile-${version}";
  version = "3.3.1";

  src = fetchurl {
    url = "http://files.salome-platform.org/Salome/other/med-${version}.tar.gz";
    sha256 = "1215sal10xp6xirgggdszay2bmx0sxhn9pgh7x0wg2w32gw1wqyx";
  };

  buildInputs = [ cmake hdf5 ];

  checkPhase = "make test";

  postInstall = "rm -r $out/bin/testc";

  meta = with stdenv.lib; {
    description = "Library to read and write MED files";
    homepage = http://salome-platform.org/;
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
