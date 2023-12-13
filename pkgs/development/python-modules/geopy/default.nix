{ lib
, async-generator
, buildPythonPackage
, docutils
, fetchFromGitHub
, geographiclib
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "2.4.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-mlOXDEtYry1IUAZWrP2FuY/CGliUnCPYLULnLNN0n4Y=";
  };

  propagatedBuildInputs = [
    geographiclib
  ];

  nativeCheckInputs = [
    async-generator
    docutils
    pytestCheckHook
    pytz
  ];

  disabledTests = [
    # ignore --skip-tests-requiring-internet flag
    "test_user_agent_default"
  ];

  pytestFlagsArray = [ "--skip-tests-requiring-internet" ];

  pythonImportsCheck = [ "geopy" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    changelog = "https://github.com/geopy/geopy/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
