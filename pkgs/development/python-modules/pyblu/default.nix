{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pyblu";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LouisChrist";
    repo = "pyblu";
    rev = "refs/tags/v${version}";
    hash = "sha256-2gpd7oDDmjUVm7bEED2ZK/27a8XUITxU0ylRfxeg/qU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    xmltodict
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
