{
  lib,
  stdenv,
  fetchurl,
  cmake,
  hdf5,
}:

stdenv.mkDerivation rec {
  pname = "medfile";
  version = "4.1.1";

  src = fetchurl {
    url = "http://files.salome-platform.org/Salome/other/med-${version}.tar.gz";
    sha256 = "sha256-3CtdVOvwZm4/8ul0BB0qsNqQYGEyNTcCOrFl1XM4ndA=";
  };

  patches = [
    ./hdf5-1.14.patch
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
