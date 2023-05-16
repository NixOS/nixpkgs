{ lib
<<<<<<< HEAD
, async-generator
=======
, async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-3Sq76DcnoG0Uv/KPF/B3oep0MO96vemKiANjgR7/k/I=";
=======
    hash = "sha256-bHfjUfuiEH3AxRDTLmbm67bKOw6fBuMQDUQA2NLg800=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    geographiclib
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    async-generator
=======
    async_generator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
