{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  bittensor-core,
  eth-account,
  qrcode,
  rich,
  typer,
  typing-extensions,
  websockets,
  cryptography,
  hypothesis,
  pytest-asyncio,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bittensor";
  version = "11.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-gQFk+1/iw1MP/fZ8DRiOWmGIOEHPmHTZy0G5qh7P5ps=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bittensor-core
    eth-account
    qrcode
    rich
    typer
    websockets
  ]
  ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  nativeCheckInputs = [
    cryptography
    hypothesis
    pytest-asyncio
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "bittensor" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python SDK and command line client for the Bittensor chain";
    homepage = "https://github.com/RaoFoundation/subtensor";
    changelog = "https://pypi.org/project/bittensor/${finalAttrs.version}/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
    mainProgram = "btcli";
  };
})
