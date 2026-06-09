{
  lib,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  setuptools,
  geographiclib,
  pytest7CheckHook,
  pythonAtLeast,
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "geopy";
  version = "2.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "geopy";
    repo = "geopy";
    tag = finalAttrs.version;
    hash = "sha256-mlOXDEtYry1IUAZWrP2FuY/CGliUnCPYLULnLNN0n4Y=";
  };

  build-system = [ setuptools ];

  dependencies = [ geographiclib ];

  nativeCheckInputs = [
    docutils
    pytest7CheckHook
    pytz
  ];

  disabledTests = [
    # ignore --skip-tests-requiring-internet flag
    "test_user_agent_default"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [ "test/test_init.py" ];

  pytestFlags = [ "--skip-tests-requiring-internet" ];

  pythonImportsCheck = [ "geopy" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    changelog = "https://github.com/geopy/geopy/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
})
