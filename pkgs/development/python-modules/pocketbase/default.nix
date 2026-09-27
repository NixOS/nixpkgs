{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  uv-build,
  # Dependencies
  httpx,
  # Tests
  pytestCheckHook,
  pytest-httpx,
}:

buildPythonPackage (finalAttrs: {
  pname = "pocketbase";
  version = "0.17.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vaphes";
    repo = "pocketbase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lHy2CPJ8LBtnVf3WSqZvKQZHdSuYVffiSLoNBN97sEE=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    httpx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpx
  ];
  pythonImportsCheck = [
    "pocketbase"
  ];
  enabledTestPaths = [
    "tests/"
  ];
  disabledTestPaths = [
    # Tests under tests/integration requires additional dependencies.
    "tests/integration"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PocketBase client SDK for python";
    homepage = "https://github.com/vaphes/pocketbase";
    changelog = "https://github.com/vaphes/pocketbase/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
