args: with args;

stdenv.mkDerivation rec {
  name = "kdeedu-4.0.0";
  
  src = fetchurl {
    url = http://download.kde.org/stable/4.0.0/src/kdeedu-4.0.0.tar.bz2;
    md5 = "73924e158e4a2de2107be441c808251f";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace boost readline openbabel ocaml
  libusb facile python];
  myCmakeFiles = ./myCmakeFiles;
  patchPhase = "
  cp ${myCmakeFiles}/* ../cmake/modules
  sed -e 's@+facile@\${LIBFACILE_INCLUDE_DIR}@' -i \\
  ../kalzium/src/CMakeOCamlInstructions.cmake
  ";
  configureFlags = "--debug-trycompile";
}
