{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyjwt
, ratelimit
<<<<<<< HEAD
=======
, pytz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "pyflume";
<<<<<<< HEAD
  version = "0.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.10";
=======
  version = "0.7.1";
  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ChrisMandich";
    repo = "PyFlume";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-RtzbAXjMtvKc8vnZIxIJnc6CS+BrYcQgdy5bVaJumg0=";
=======
    rev = "v${version}";
    hash = "sha256-Ka90n9Esv6tm310DjYeosBUhudeVoEJzt45L40+0GwQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyjwt
    ratelimit
<<<<<<< HEAD
=======
    pytz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "pyflume"
  ];
=======
  pythonImportsCheck = [ "pyflume" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python module to work with Flume sensors";
    homepage = "https://github.com/ChrisMandich/PyFlume";
<<<<<<< HEAD
    changelog = "https://github.com/ChrisMandich/PyFlume/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
