{ lib, stdenv, fetchurl, cmake, hdf5 }:

stdenv.mkDerivation rec {
  pname = "medfile";
  version = "4.1.0";

  src = fetchurl {
    url = "http://files.salome-platform.org/Salome/other/med-${version}.tar.gz";
    sha256 = "1khzclkrd1yn9mz3g14ndgpsbj8j50v8dsjarcj6kkn9zgbbazc4";
  };

  patches = [
    ./hdf5-1.12.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ hdf5 ];

  checkPhase = "make test";

  postInstall = "rm -r $out/bin/testc";

  meta = with lib; {
    description = "Library to read and write MED files";
    homepage = "http://salome-platform.org/";
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
  };
}
