{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "airgradient";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "airgradienthq";
    repo = "python-airgradient";
    tag = "v${version}";
    hash = "sha256-llhdLqVueATKCb4wyPYjnsdOpbbE2BnUU0PH0jwHPMU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "airgradient" ];

  meta = {
    description = "Module for AirGradient";
    homepage = "https://github.com/airgradienthq/python-airgradient";
    changelog = "https://github.com/airgradienthq/python-airgradient/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
