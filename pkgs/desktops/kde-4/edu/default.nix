args: with args;

stdenv.mkDerivation rec {
  name = "kdeedu-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "1j0swj38qdx0azm2dnx4l7if5dxak1pmcr90ynfjrcifkm68mm3k";
  };

  propagatedBuildInputs = [kde4.pimlibs boost readline openbabel ocaml libusb
  facile python indilib libnova kde4.support.eigen];
  buildInputs = [cmake];
  myCmakeFiles = ./myCmakeFiles;
  patchPhase = "
  cp ${myCmakeFiles}/* ../cmake/modules
  sed -e 's@+facile@\${LIBFACILE_INCLUDE_DIR}@' -i \\
  ../kalzium/src/CMakeOCamlInstructions.cmake
  ";
}
