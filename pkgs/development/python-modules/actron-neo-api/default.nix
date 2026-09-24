{
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "actron-neo-api";
  version = "0.5.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kclif9";
    repo = "actronneoapi";
    tag = "v${version}";
    hash = "sha256-5ijykxSZmCUInMezP/8GCuOXIxwOb7Kc9Zqr9/+ZPvU=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
    aiomqtt
    pydantic
  ];

  pythonImportsCheck = [ "actron_neo_api" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/kclif9/actronneoapi/releases/tag/${src.tag}";
    description = "Communicate with Actron Air systems via the Actron Neo API";
    homepage = "https://github.com/kclif9/actronneoapi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
