{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pywizlight";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sbidy";
    repo = "pywizlight";
    rev = "v${version}";
    hash = "sha256-JT0Ud17U9etByaDVu9+hcadymze1rfj+mEK6nqksuWc=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  disabledTests = [
    # Tests requires network features (e. g., discovery testing)
    "test_Bulb_Discovery"
    "test_timeout"
    "test_timeout_PilotBuilder"
    "test_error_PilotBuilder_warm_wite"
    "test_error_PilotBuilder_cold_white_lower"
  ];

  pythonImportsCheck = [ "pywizlight" ];

  meta = with lib; {
    description = "Python connector for WiZ light bulbs";
    mainProgram = "wizlight";
    homepage = "https://github.com/sbidy/pywizlight";
    changelog = "https://github.com/sbidy/pywizlight/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
