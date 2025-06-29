{
  lib,
  buildPythonPackage,
  fetchPypi,
  latexcodec,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.25.1";
  format = "setuptools";
  pname = "pybtex";

  doCheck = false;
  pythonImportsCheck = [ "pybtex" ];

  propagatedBuildInputs = [
    latexcodec
    pyyaml
    setuptools
  ];

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-nq+QJnx+g+Ilr4n+plw3Cvv2X0WCINOUap4wSeHspJE=";
  };

  meta = with lib; {
    homepage = "https://pybtex.org/";
    description = "BibTeX-compatible bibliography processor written in Python";
    license = licenses.mit;
  };
}
