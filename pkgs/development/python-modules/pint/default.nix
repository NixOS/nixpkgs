{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
<<<<<<< HEAD

# build-system
, setuptools
, setuptools-scm

# propagates
, typing-extensions

# tests
=======
, setuptools-scm
, importlib-metadata
, packaging
# Check Inputs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pytest-subtests
, numpy
, matplotlib
, uncertainties
}:

buildPythonPackage rec {
  pname = "pint";
<<<<<<< HEAD
  version = "0.22";
  format = "pyproject";
=======
  version = "0.20.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
<<<<<<< HEAD
    hash = "sha256-LROfarvPMBbK19POwFcH/pCKxPmc9Zrt/W7mZ7emRDM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];
=======
    hash = "sha256-OHzwQHjcff5KcIAzuq1Uq2HYKrBsTuPUkiseRdViYGc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ packaging ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
    numpy
    matplotlib
    uncertainties
  ];

<<<<<<< HEAD
=======
  dontUseSetuptoolsCheck = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

<<<<<<< HEAD
  disabledTests = [
    # https://github.com/hgrecco/pint/issues/1825
    "test_equal_zero_nan_NP"
  ];

  meta = with lib; {
    changelog = "https://github.com/hgrecco/pint/blob/${version}/CHANGES";
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [ doronbehar ];
=======
  meta = with lib; {
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [ costrouc doronbehar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
