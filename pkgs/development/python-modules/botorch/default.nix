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
  version = "0.11.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YX/G46U09y/VZuWZhKY8zU0Y+bf0NKumzSGYUWvrq/0=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    gpytorch
    linear-operator
    multipledispatch
    pyro-ppl
    scipy
    torch
  ];

  pythonRelaxDeps = [
    "gpytorch"
    "linear-operator"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "botorch" ];

  meta = with lib; {
    description = "Bayesian Optimization in PyTorch";
    homepage = "https://botorch.org";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
