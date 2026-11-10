{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywizlight";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbidy";
    repo = "pywizlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rCoWdqvFLSLNBAHeFJ6f9kZpIg4WyE8VJLpmsYl+gJM=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  disabledTests = [
    # Tests requires network features (e. g., discovery testing)
    "test_Bulb_Discovery"
    "test_timeout"
    "test_timeout_PilotBuilder"
    "test_error_PilotBuilder_warm_wite"
    "test_error_PilotBuilder_cold_white_lower"
  ];

  pythonImportsCheck = [ "pywizlight" ];

  passthru = {
    # 0.6.4 made `wizlight.state` a list (multi-zone bulbs), which the wiz
    # component of Home Assistant, the only user, can't handle yet; update
    # once its manifest requires >= 0.6.4 (home-assistant/core#177502)
    skipBulkUpdate = true; # nixpkgs-update: no auto update
  };

  meta = {
    description = "Python connector for WiZ light bulbs";
    homepage = "https://github.com/sbidy/pywizlight";
    changelog = "https://github.com/sbidy/pywizlight/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wizlight";
  };
})
