{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  setuptools,
  # Dependencies
  httpx,
  pycryptodome,
  requests,
  requests-toolbelt,
  websockets,
  # Optional dependencies
  aiohttp,
  fastapi,
  uvicorn,
  flask,
  # Tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lark-oapi";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "larksuite";
    repo = "oapi-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6EYLE+RiDd9ZNjwQ4gWW6jsipFjJCE7CZsSsxIenE6w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    pycryptodome
    requests
    requests-toolbelt
    websockets
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    fastapi = [
      fastapi
      uvicorn
    ];
    flask = [
      flask
    ];
  };

  # websockets 16.0 is compatible despite the <16 metadata constraint
  pythonRelaxDeps = [ "websockets" ];

  # Tests
  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lark_oapi" ];

  enabledTestPaths = [
    "lark_oapi/channel/tests"
  ];

  disabledTestPaths = [
    "lark_oapi/channel/tests/test_client_lifecycle.py" # Inconsistent test
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Larksuite development interface SDK";
    homepage = "https://github.com/larksuite/oapi-sdk-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      knightfemale
      LodWKobku
    ];
  };
})
