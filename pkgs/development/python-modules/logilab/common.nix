{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, importlib-metadata
, mypy-extensions
, typing-extensions
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "logilab-common";
<<<<<<< HEAD
  version = "1.10.0";
=======
  version = "1.9.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-MoXt3tta5OimJUjOkWSMDCmXV0aS8N0W5bcANwAelYY=";
=======
    hash = "sha256-/JlN9RlIRLbi9TL9V6SgO6ddPeKqLzK402DqkLBRuxM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mypy-extensions
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  preCheck = ''
    export COLLECT_DEPRECATION_WARNINGS_PACKAGE_NAME=true
  '';

  meta = with lib; {
    description = "Python packages and modules used by Logilab ";
    homepage = "https://logilab-common.readthedocs.io/";
    changelog = "https://forge.extranet.logilab.fr/open-source/logilab-common/-/blob/branch/default/CHANGELOG.md";
    license = licenses.lgpl21Plus;
  };
}
