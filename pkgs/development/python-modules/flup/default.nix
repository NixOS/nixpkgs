{ stdenv, fetchurl, python, setuptools, ... }:

stdenv.mkDerivation rec {
  name = "flup-r2311";

  src = fetchurl {
    url = "http://www.saddi.com/software/flup/dist/${name}.tar.gz";
    sha256 = "15wyn6d6wla1ag91yxmlh9b4m0w1i0c2lm8ka4qfv4ijqcqakdx3";
  };

  buildInputs = [ python setuptools ];

  phaseNames = ["addInputs" "createPythonInstallationTarget" "installPythonPackage"];

  meta = {
    description = "FastCGI Python module set";
  };
}
