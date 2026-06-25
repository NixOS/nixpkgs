{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  setuptools,
  # Dependencies
  aiohttp,
  apscheduler,
  pyyaml,
  # Tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "qq-botpy";
  version = "1.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tencent-connect";
    repo = "botpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+wc8yY/wY1Vlar+GH4U2Tjmb6sO5XdRJLERrsICJ4jc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    apscheduler
    pyyaml
  ];

  preCheck = ''
    # Fix wrong test filename
    cp tests/".test(demo).yaml" tests/.test.yaml
  '';
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [
    "botpy"
  ];
  enabledTestPaths = [
    "tests/"
  ];
  disabledTestPaths = [
    # Requires connection to QQ servers
    "tests/test_api.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python SDK for QQ channel bot";
    homepage = "https://github.com/tencent-connect/botpy";
    changelog = "https://github.com/tencent-connect/botpy/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
