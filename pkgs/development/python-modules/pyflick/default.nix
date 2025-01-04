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
  pname = "py-flick";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ZephireNZ";
    repo = "PyFlick";
    tag = "v${version}";
    hash = "sha256-Csm5gXMIGEhHgzN/7sO/1iM/wZklI2Jc0C69tgYWxnQ=";
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
