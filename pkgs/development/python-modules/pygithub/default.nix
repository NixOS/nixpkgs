{ lib
, buildPythonPackage
<<<<<<< HEAD
, deprecated
, fetchFromGitHub
, pynacl
, typing-extensions
, pyjwt
, python-dateutil
, pythonOlder
, requests
, setuptools-scm
=======
, cryptography
, deprecated
, fetchFromGitHub
, pynacl
, pyjwt
, pythonOlder
, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pygithub";
<<<<<<< HEAD
  version = "1.59.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.58.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-tzM2+nLBHTbKlQ7HLmNRq4Kn62vmz1MaGyZsnaJSrgQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    deprecated
    pyjwt
    pynacl
    python-dateutil
    requests
    typing-extensions
  ] ++ pyjwt.optional-dependencies.crypto;

  # Test suite makes REST calls against github.com
  doCheck = false;

  pythonImportsCheck = [
    "github"
  ];
=======
    hash = "sha256-DZmKF0C5zexTQ/kbDtTg0FLEocNU4dYMOFCJyvuiV98=";
  };

  propagatedBuildInputs = [
    cryptography
    deprecated
    pynacl
    pyjwt
    requests
  ];

  # Test suite makes REST calls against github.com
  doCheck = false;
  pythonImportsCheck = [ "github" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python library to access the GitHub API v3";
    homepage = "https://github.com/PyGithub/PyGithub";
    changelog = "https://github.com/PyGithub/PyGithub/raw/v${version}/doc/changes.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jhhuh ];
  };
}
