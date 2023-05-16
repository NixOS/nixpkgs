{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, requests
<<<<<<< HEAD
, segno
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "fritzconnection";
<<<<<<< HEAD
  version = "1.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-FTg5LHjti6Srmz1LcPU0bepNzn2tpmdSBM3Y2BzZEms=";
=======
    hash = "sha256-1giXmmyuy+qrY6xV3yZn4kcDd6w6l8uCL4ozcZE4N00=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    qr = [
      segno
    ];
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  pythonImportsCheck = [
    "fritzconnection"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    # Functional tests require network access
    "fritzconnection/tests/test_functional.py"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python module to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/version_history.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
