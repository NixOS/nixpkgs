{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7389d06a7ea50c80ca51eda1b185db7b9ec38af1304d12d8b8299d6218486e91";
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
