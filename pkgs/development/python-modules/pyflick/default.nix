{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  json-api-doc,
  python-dateutil,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyflick";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ZephireNZ";
    repo = "PyFlick";
    tag = "v${version}";
    hash = "sha256-JROtklRimr6I1/6+yYaDL6rNGSj7O15nI/C9ZSj6eFo=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    json-api-doc
    python-dateutil
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pyflick"
    "pyflick.authentication"
  ];

  meta = {
    description = "Python API For Flick Electric in New Zealand";
    homepage = "https://github.com/ZephireNZ/PyFlick";
    changelog = "https://github.com/ZephireNZ/PyFlick/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
