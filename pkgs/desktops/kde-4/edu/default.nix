args: with args;

stdenv.mkDerivation rec {
  name = "kdeedu-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdeedu-4.0.0.tar.bz2;
    sha256 = "1wjy1rm7aiib1lv61wx7mcbkbpkk6phcz1q6dy51x0hfrc3rdkg4";
  };

  propagatedBuildInputs = [kdepimlibs boost readline openbabel ocaml libusb
  facile python indilib libnova];
  buildInputs = [cmake];
  myCmakeFiles = ./myCmakeFiles;
  patchPhase = "
  cp ${myCmakeFiles}/* ../cmake/modules
  sed -e 's@+facile@\${LIBFACILE_INCLUDE_DIR}@' -i \\
  ../kalzium/src/CMakeOCamlInstructions.cmake
  ";
}
