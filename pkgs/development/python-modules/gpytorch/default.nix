{ lib
, buildPythonPackage
, fetchFromGitHub
, linear_operator
, scikit-learn
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, torch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gpytorch";
<<<<<<< HEAD
  version = "1.11";
=======
  version = "1.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cpkfjx5G/4duL1Rr4nkHTHi03TDcYbcx3bKP2Ny7Ijo=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];
=======
    hash = "sha256-KY3ItkVjBfIYMkZAmD56EBGR9YN/MRN7b2K3zrK6Qmk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'find_version("gpytorch", "version.py")' \"$version\"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    linear_operator
    scikit-learn
    torch
  ];

  checkInputs = [
    pytestCheckHook
  ];
<<<<<<< HEAD

  pythonImportsCheck = [ "gpytorch" ];

=======
  pythonImportsCheck = [ "gpytorch" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTests = [
    # AssertionError on number of warnings emitted
    "test_deprecated_methods"
    # flaky numerical tests
    "test_classification_error"
    "test_matmul_matrix_broadcast"
<<<<<<< HEAD
    # https://github.com/cornellius-gp/gpytorch/issues/2396
    "test_t_matmul_matrix"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "A highly efficient and modular implementation of Gaussian Processes, with GPU acceleration";
    homepage = "https://gpytorch.ai";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
