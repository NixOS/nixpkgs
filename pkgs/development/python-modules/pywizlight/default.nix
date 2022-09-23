{ lib
, asyncio-dgram
, buildPythonPackage
, click
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pywizlight";
  version = "0.5.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sbidy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IkuAYEg5nuUT6zxmuJe6afp4MVWf0+HAnEoAdOrdTvQ=";
  };

  propagatedBuildInputs = [
    asyncio-dgram
    click
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  disabledTests = [
    # Tests requires network features (e. g., discovery testing)
    "test_Bulb_Discovery"
    "test_timeout"
    "test_timeout_PilotBuilder"
    "test_error_PilotBuilder_warm_wite"
    "test_error_PilotBuilder_cold_white_lower"
  ];

  pythonImportsCheck = [
    "pywizlight"
  ];

  meta = with lib; {
    description = "Python connector for WiZ light bulbs";
    homepage = "https://github.com/sbidy/pywizlight";
    changelog = "https://github.com/sbidy/pywizlight/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
