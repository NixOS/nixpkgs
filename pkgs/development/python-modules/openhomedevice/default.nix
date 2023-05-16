{ lib
<<<<<<< HEAD
, aioresponses
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, async-upnp-client
, buildPythonPackage
, fetchFromGitHub
, lxml
<<<<<<< HEAD
, pytestCheckHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "openhomedevice";
<<<<<<< HEAD
  version = "2.2";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bazwilliams";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-GGp7nKFH01m1KW6yMkKlAdd26bDi8JDWva6OQ0CWMIw=";
=======
    rev = version;
    hash = "sha256-D4n/fv+tgdKiU7CemI+12cqoox2hsqRYlCHY7daD5fM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    async-upnp-client
    lxml
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];
=======
  # Tests are currently outdated
  # https://github.com/bazwilliams/openhomedevice/issues/20
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "openhomedevice"
  ];

<<<<<<< HEAD
  pytestFlagsArray = [
    "tests/*.py"
  ];

  meta = with lib; {
    description = "Python module to access Linn Ds and Openhome devices";
    homepage = "https://github.com/bazwilliams/openhomedevice";
    changelog = "https://github.com/bazwilliams/openhomedevice/releases/tag/${version}";
=======
  meta = with lib; {
    description = "Python module to access Linn Ds and Openhome devices";
    homepage = "https://github.com/bazwilliams/openhomedevice";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
