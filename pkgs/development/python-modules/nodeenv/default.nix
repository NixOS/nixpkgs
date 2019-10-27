{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad8259494cf1c9034539f6cced78a1da4840a4b157e23640bc4a0c0546b0cb7a";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Node.js virtual environment builder";
    homepage = https://github.com/ekalinin/nodeenv;
    license = licenses.bsd3;
  };
}
