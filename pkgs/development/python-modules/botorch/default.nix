{ lib
, buildPythonPackage
, fetchFromGitHub
, gpytorch
, linear-operator
, multipledispatch
, pyro-ppl
, setuptools
, setuptools-scm
, wheel
, torch
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "botorch";
  version = "0.9.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-M/VOt0p7io0K+VHrAmBJQ71VigH0Ll1D5it6+/o/3jg=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    gpytorch
    linear-operator
    multipledispatch
    pyro-ppl
    scipy
    torch
  ];

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
