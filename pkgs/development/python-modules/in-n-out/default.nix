{ lib
, buildPythonPackage
, cython_3
, fetchPypi
, future
, pytestCheckHook
, pythonAtLeast
, pythonOlder
<<<<<<< HEAD
, hatchling
, hatch-vcs
=======
, setuptools
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, toolz
}:

buildPythonPackage rec {
  pname = "in-n-out";
<<<<<<< HEAD
  version = "0.1.8";
  format = "pyproject";
=======
  version = "0.1.6";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  src = fetchPypi {
<<<<<<< HEAD
    pname = "in_n_out";
    inherit version;
    hash = "sha256-gWKvh4fmgutLNtBH+RQZnYDxEk46QUIM1T3mgOfQolQ=";
=======
    inherit pname version;
    hash = "sha256-PuzjidORMFVlmFZbmnu9O92FoiuXrC8NNRyjwdodriY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython_3
<<<<<<< HEAD
    hatchling
    hatch-vcs
=======
    setuptools
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    future
  ];

  nativeCheckInputs = [
    pytestCheckHook
    toolz
  ];

  pythonImportsCheck = [
    "in_n_out"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.11") [
    # Fatal Python error
    "tests/test_injection.py"
    "tests/test_processors.py"
    "tests/test_providers.py"
    "tests/test_store.py"
  ];

  meta = with lib; {
    description = "Module for dependency injection and result processing";
<<<<<<< HEAD
    homepage = "https://github.com/pyapp-kit/in-n-out";
=======
    homepage = "https://app-model.readthedocs.io/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    changelog = "https://github.com/pyapp-kit/in-n-out/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
