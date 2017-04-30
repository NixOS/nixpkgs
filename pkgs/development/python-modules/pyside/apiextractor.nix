{ stdenv, fetchurl, cmake, libxml2, libxslt, python2, qt4 }:

# This derivation does not provide any Python module and should therefore be called via `all-packages.nix`.
let
  pythonEnv = python2.withPackages(ps: with ps; [  sphinx ]);
in stdenv.mkDerivation {
  name = "pyside-apiextractor-0.10.10";

  src = fetchurl {
    url = "https://github.com/PySide/Apiextractor/archive/0.10.10.tar.gz";
    sha256 = "1zj8yrxy08iv1pk38djxw3faimm226w6wmi0gm32w4yczblylwz3";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake qt4 pythonEnv libxml2 libxslt ];

  meta = {
    description = "Eases the development of bindings of Qt-based libraries for high level languages by automating most of the process";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://www.pyside.org/docs/apiextractor/";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.all;
  };
}
