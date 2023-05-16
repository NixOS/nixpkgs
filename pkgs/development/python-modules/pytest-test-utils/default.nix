{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
<<<<<<< HEAD
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-test-utils";
  version = "0.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5gB+hnJR2+NQd/n7RGrX1bzfKt8Np7IbWw61SZgNVJY=";
  };

<<<<<<< HEAD
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
=======
  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_test_utils"
  ];

  meta = with lib; {
    description = "Pytest utilities for tests";
    homepage = "https://github.com/iterative/pytest-test-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
