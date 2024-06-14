{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gpytorch,
  linear-operator,
  multipledispatch,
  pyro-ppl,
  setuptools,
  setuptools-scm,
  wheel,
  torch,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "botorch";
  version = "0.11.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eL0buwqrGt4qcwdzCwD85IyiWjAFuP1n8aUb2pvvIKw=";
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

  pythonRelaxDeps = [ "linear-operator" ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "botorch" ];

  meta = with lib; {
    description = "Bayesian Optimization in PyTorch";
    homepage = "https://botorch.org";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
