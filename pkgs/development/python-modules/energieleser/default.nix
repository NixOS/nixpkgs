{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "energieleser";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nineti-GmbH";
    repo = "energieleser.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vJ4eJaf0ue4N9aXwsPR79sTVt3NM1GKNw5XomhQUUdU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "energieleser" ];

  meta = {
    description = "Async Python client for energieleser devices (stromleser, gasleser, wasserleser, wärmeleser)";
    homepage = "https://github.com/nineti-GmbH/energieleser.py";
    changelog = "https://github.com/nineti-GmbH/energieleser.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
