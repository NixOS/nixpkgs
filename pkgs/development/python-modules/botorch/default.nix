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
  torch,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "botorch";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "botorch";
    rev = "refs/tags/v${version}";
    hash = "sha256-AtRU5KC8KlkxMCU0OUAHDFK7BsPO3TbRmmzDGV7+yVk=";
  };

  build-system = [
    setuptools
    setuptools-scm
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

  disabledTests = [ "test_all_cases_covered" ];

  pythonImportsCheck = [ "botorch" ];

  meta = with lib; {
    changelog = "https://github.com/pytorch/botorch/blob/${src.rev}/CHANGELOG.md";
    description = "Bayesian Optimization in PyTorch";
    homepage = "https://botorch.org";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
