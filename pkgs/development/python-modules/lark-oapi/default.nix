{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  requests-toolbelt,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "lark-oapi";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "larksuite";
    repo = "oapi-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A2cjYwa1HAMTXHfi6jPaASD++Ca8ozsDvYFv19gXIgw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    pycryptodome
    requests
    requests-toolbelt
    websockets
  ];

  # websockets 16.0 is compatible despite the <16 metadata constraint
  pythonRelaxDeps = [ "websockets" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # stop() doesn't cancel the in-flight bot identity fetch,
  # so start() can block for up to 10s while the test only waits 2s.
  # https://github.com/larksuite/oapi-sdk-python/issues/159
  disabledTests = [
    "test_stop_during_pre_ws_start_prevents_late_ws_creation"
  ];

  pythonImportsCheck = [ "lark_oapi" ];

  meta = {
    description = "Larksuite development interface SDK";
    homepage = "https://github.com/larksuite/oapi-sdk-python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.knightfemale ];
  };
})
