{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, jaxtyping
, pytestCheckHook
, scipy
, setuptools
, setuptools-scm
, torch
, wheel
=======
, scipy
, torch
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "linear_operator";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7NkcvVDwFaLHBZZhq7aKY3cWxe90qeKmodP6cVsdrPM=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    jaxtyping
=======
    hash = "sha256-0f3F3k3xJACbx42jtwsAmjZwPAOfLywZs8VOrwWicc4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'find_version("linear_operator", "version.py")' \"$version\"
  '';

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    scipy
    torch
  ];

<<<<<<< HEAD
  pythonImportsCheck = [ "linear_operator" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

=======
  checkInputs = [
    pytestCheckHook
  ];
  pythonImportsCheck = [ "linear_operator" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTests = [
    # flaky numerical tests
    "test_svd"
  ];

  meta = with lib; {
    description = "A LinearOperator implementation to wrap the numerical nuts and bolts of GPyTorch";
    homepage = "https://github.com/cornellius-gp/linear_operator/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
