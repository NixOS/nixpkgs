{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-util";
<<<<<<< HEAD
  version = "3.10";
  format = "pyproject";

  disabled = pythonOlder "3.10";
=======
  version = "3.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.util";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-H89lPX//AlTEJLuZFzzn9wUc4lZC1TGd98t4+TYlbWs=";
=======
    hash = "sha256-uITIEiy4U2B0AQobvQIG/bYjelPmM8fyQduDhtC29QI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.util"
  ];

  meta = with lib; {
    description = "Dissect module implementing various utility functions for the other Dissect modules";
    homepage = "https://github.com/fox-it/dissect.util";
    changelog = "https://github.com/fox-it/dissect.util/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
