{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  lxml,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyblu";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LouisChrist";
    repo = "pyblu";
    tag = "v${version}";
    hash = "sha256-nzTqakEMl9gywIQpC9OR0xiqZzawU5RxOx3NQT+CiFc=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    lxml
  ];

  pythonImportsCheck = [ "pyblu" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/LouisChrist/pyblu/releases/tag/v${version}";
    description = "BluOS API client";
    homepage = "https://github.com/LouisChrist/pyblu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
