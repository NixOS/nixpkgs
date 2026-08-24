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
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nineti-GmbH";
    repo = "energieleser.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bg+XdASeegWLWU7kjywmMSih3SarVB3Mc2YHVCnU93w=";
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
