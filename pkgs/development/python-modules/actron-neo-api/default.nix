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
  version = "0.5.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kclif9";
    repo = "actronneoapi";
    tag = "v${version}";
    hash = "sha256-j7qjVkpZFkWLVQd+/ndnjPOi8/xo357ez6yte78ny5U=";
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
