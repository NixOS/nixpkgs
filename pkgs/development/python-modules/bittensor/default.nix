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
  version = "11.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-l75+nVI8o22T7dx7ljGLQqe72VErU8dXxYB6fa+0Nx0=";
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
