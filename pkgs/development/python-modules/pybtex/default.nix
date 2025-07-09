{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  latexcodec,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pybtex";
  version = "0.24.0";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    sha256 = "818eae35b61733e5c007c3fcd2cfb75ed1bc8b4173c1f70b56cc4c0802d34755";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    latexcodec
    pyyaml
  ];

  pythonImportsCheck = [ "pybtex" ];

  doCheck = false;

  meta = {
    homepage = "https://pybtex.org/";
    changelog = "https://bitbucket.org/pybtex-devs/pybtex/src/master/CHANGES";
    description = "BibTeX-compatible bibliography processor written in Python";
    license = lib.licenses.mit;
  };
}
