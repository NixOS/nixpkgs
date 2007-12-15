args: with args;

stdenv.mkDerivation rec {
  name = "kdeedu-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdeedu-3.97.0.tar.bz2;
    sha256 = "1d2319pzs4ymbp2jgmc1kzkr5d9g5p5d1yg6b5l7z4b2qzhchpl4";
  };

  buildInputs = [kdelibs kdepimlibs boost readline openbabel ocaml
  libusb facile python];
  myCmakeFiles = ./myCmakeFiles;
  patchPhase = "
  cp ${myCmakeFiles}/* ../cmake/modules
  sed -e 's@+facile@\${LIBFACILE_INCLUDE_DIR}@' -i \\
  ../kalzium/src/CMakeOCamlInstructions.cmake
  ";
}
