{ lib, stdenv, fetchFromGitHub, cmake, pysideApiextractor, python3, qt4 }:

# This derivation does not provide any Python module and should therefore be called via `all-packages.nix`.
let
  pythonEnv = python3.withPackages(ps: with ps; [ sphinx ]);
in stdenv.mkDerivation rec {
  pname = "pyside-generatorrunner";
  version = "0.6.16";

  src = fetchFromGitHub {
    owner = "PySide";
    repo = "Generatorrunner";
    rev = version;
    hash = "sha256-JAghKY033RTD5b2elitzVQbbN3PMmT3BHwpqx8N5EYg=";
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
