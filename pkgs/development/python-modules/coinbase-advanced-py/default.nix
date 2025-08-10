{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pythonRelaxDepsHook,
  requests,
  cryptography,
  pyjwt,
  websockets,
  backoff,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "coinbase-advanced-py";
  version = "1.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "coinbase";
    repo = "coinbase-advanced-py";
    tag = "v${version}";
    hash = "sha256-1XJ4QnFJVSbSCfkB16+UTARXqhlsy36Db3S6ju6nJUY=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "websockets"
  ];

  dependencies = [
    requests
    cryptography
    pyjwt
    websockets
    backoff
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "coinbase"
    "coinbase.rest"
    "coinbase.websocket"
  ];

  disabledTestPaths = [
    # WebSocket tests fail due to API changes in websockets >= 14.0
    "tests/websocket/"
  ];

  meta = {
    description = "Coinbase Advanced API Python SDK";
    homepage = "https://github.com/coinbase/coinbase-advanced-py";
    changelog = "https://github.com/coinbase/coinbase-advanced-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
