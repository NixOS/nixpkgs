{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pywizlight";
  version = "0.6.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sbidy";
    repo = "pywizlight";
    tag = "v${version}";
    hash = "sha256-ki4X+4s+tM3kIyhA2cxPPzG775Qz9jKFS8/ssUqfHas=";
  };

  propagatedBuildInputs = [ click ];

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

  meta = {
    description = "Python connector for WiZ light bulbs";
    mainProgram = "wizlight";
    homepage = "https://github.com/sbidy/pywizlight";
    changelog = "https://github.com/sbidy/pywizlight/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
