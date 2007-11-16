args: with args;

stdenv.mkDerivation rec {
  name = "kdeedu-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdeedu-3.95.0.tar.bz2;
    sha256 = "0cydl3pp3l0cbfmf774qh8njyhycaf8yxb27k4xf6mipvw1k9jqf";
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
