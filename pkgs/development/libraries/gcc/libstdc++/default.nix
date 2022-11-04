{gcc, stdenv}:

stdenv.mkDerivation rec {

  pname = "libstdc++";
  inherit (gcc.cc) src version;

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  preConfigure = ''
    sourceRoot=$(readlink -e "./libstdc++-v3")
    cd $buildRoot
    configureScript=$sourceRoot/configure
  '';

}
