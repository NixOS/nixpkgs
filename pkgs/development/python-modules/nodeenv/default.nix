{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ef13ff90291ba2a4a7a4ff9a979b63ffdd00a464dbe04acf0ea6471517a4c2b";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Node.js virtual environment builder";
    homepage = "https://github.com/ekalinin/nodeenv";
    license = licenses.bsd3;
  };
}
