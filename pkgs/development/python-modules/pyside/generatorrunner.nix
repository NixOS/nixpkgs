{ lib, stdenv, fetchurl, cmake, pysideApiextractor, python3, qt4 }:

# This derivation does not provide any Python module and should therefore be called via `all-packages.nix`.
let
  pythonEnv = python3.withPackages(ps: with ps; [ sphinx ]);
  pname = "pyside-generatorrunner";
  version = "0.6.16";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/PySide/Generatorrunner/archive/0.6.16.tar.gz";
    sha256 = "0vzk3cp0pfbhd921r8f1xkcz96znla39dhj074k623x9k26lj2sj";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$dev")
  '';

  nativeBuildInputs = [ cmake pythonEnv ];
  buildInputs = [ pysideApiextractor qt4 ];

  meta = with lib; {
    description = "Eases the development of binding generators for C++ and Qt-based libraries by providing a framework to help automating most of the process";
    license = licenses.gpl2;
    homepage = "http://www.pyside.org/docs/generatorrunner/";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
