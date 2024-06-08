{
  lib,
  buildPythonPackage,
  fetchPypi,
  latexcodec,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.24.0";
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
    sha256 = "818eae35b61733e5c007c3fcd2cfb75ed1bc8b4173c1f70b56cc4c0802d34755";
  };

  meta = with lib; {
    homepage = "https://pybtex.org/";
    description = "A BibTeX-compatible bibliography processor written in Python";
    license = licenses.mit;
  };
}
