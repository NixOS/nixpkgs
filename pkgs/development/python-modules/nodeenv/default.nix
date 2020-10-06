{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab45090ae383b716c4ef89e690c41ff8c2b257b85b309f01f3654df3d084bd7c";
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
