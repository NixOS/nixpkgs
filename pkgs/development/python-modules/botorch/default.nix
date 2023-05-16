{ lib
, buildPythonPackage
, fetchFromGitHub
, gpytorch
, linear_operator
, multipledispatch
, pyro-ppl
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, torch
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "botorch";
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.8.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8obS+qMQwepKUxPkMbufR/SaacYekl6FA6t6XW6llA4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

=======
    hash = "sha256-VcNHgfk8OfLJseQxHksycWuCPCudCtOdcRV0XnxHSfU=";
  };

  buildInputs = [
    setuptools-scm
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    gpytorch
    linear_operator
    multipledispatch
    pyro-ppl
    scipy
    torch
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkInputs = [
    pytestCheckHook
  ];
  pythonImportsCheck = [ "botorch" ];

  meta = with lib; {
    description = "Bayesian Optimization in PyTorch";
    homepage = "https://botorch.org";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
