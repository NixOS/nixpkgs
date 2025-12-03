{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymorphy2-dicts-ru";
  version = "2.4.417127.4579844";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eMrQOtymBQIavTh6Oy61FchRuG6UaCoe8jVKLHT8wZY=";
  };

  build-system = [
    setuptools
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pymorphy2_dicts_ru" ];

  meta = {
    description = "Russian dictionaries for pymorphy2";
    homepage = "https://github.com/kmike/pymorphy2-dicts/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
