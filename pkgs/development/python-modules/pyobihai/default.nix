{ lib
, buildPythonPackage
, defusedxml
<<<<<<< HEAD
, fetchFromGitHub
, pytestCheckHook
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyobihai";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "ejpenney";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-tDPu/ceH7+7AnxokADDfl+G56B0+ri8RxXxXEyWa61Q=";
=======
  # GitHub release, https://github.com/dshokouhi/pyobihai/issues/10
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L/AQy9IxsBDeSlu+45j+/86jjMFzTjAkPGwZoa1QYho=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    defusedxml
    requests
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
  ];
=======
  # Project has no tests
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "pyobihai"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Module to interact with Obihai devices";
    homepage = "https://github.com/ejpenney/pyobihai";
    changelog = "https://github.com/ejpenney/pyobihai/releases/tag/${version}";
=======
    description = "Python package to interact with Obihai devices";
    homepage = "https://github.com/dshokouhi/pyobihai";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
