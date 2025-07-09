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

  meta = {
    homepage = "https://pybtex.org/";
    changelog = "https://bitbucket.org/pybtex-devs/pybtex/src/master/CHANGES";
    description = "BibTeX-compatible bibliography processor written in Python";
    license = lib.licenses.mit;
  };
}
