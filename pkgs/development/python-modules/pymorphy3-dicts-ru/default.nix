{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymorphy3-dicts-ru";
  version = "2.4.417150.4580142";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oas3nUypBbr+1Q9a/Do95vlkNgV3b7yrxNMIjU7TgrA=";
  };

  build-system = [
    setuptools
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pymorphy3_dicts_ru" ];

  meta = {
    description = "Russian dictionaries for pymorphy3";
    homepage = "https://github.com/no-plagiarism/pymorphy3-dicts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
