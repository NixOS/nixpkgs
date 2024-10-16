{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  lxml,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyblu";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LouisChrist";
    repo = "pyblu";
    rev = "refs/tags/v${version}";
    hash = "sha256-1H7TqFPVstB+nCYwWOT8E2HcmkLQx9pekBq2WIAf8DQ=";
  };

  build-system = [ poetry-core ];

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
