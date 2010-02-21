{ stdenv, fetchurl, python, setuptools, ... }:

rec {
  name = "flup-1.0.2";

  src = fetchurl {
    url = "http://www.saddi.com/software/flup/dist/${name}.tar.gz";
    sha256 = "1nbx174g40l1z3a8arw72qz05a1qxi3didp9wm7kvkn1bxx33bab";
  };

  buildInputs = [ python setuptools ];

  phaseNames = ["addInputs" "createPythonInstallationTarget" "installPythonPackage"];

  meta = {
    description = "FastCGI Python module set";
  };
}
