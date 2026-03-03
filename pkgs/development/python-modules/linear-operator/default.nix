{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jaxtyping,
  pytestCheckHook,
  scipy,
  setuptools,
  setuptools-scm,
  torch,
  typeguard,
}:

buildPythonPackage rec {
  pname = "linear-operator";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = "linear_operator";
    tag = "v${version}";
    hash = "sha256-Ghe4a3zMSvTv3J6ROd1RLELK+k24/rO8p+XUPVsl090=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jaxtyping
    scipy
    torch
    typeguard
  ];

  pythonRelaxDeps = [
    "jaxtyping"
    "typeguard"
  ];

  pythonImportsCheck = [ "linear_operator" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # flaky numerical tests
    "test_matmul_matrix_broadcast"
    "test_solve_matrix_broadcast"
    "test_svd"
  ];

  meta = {
    description = "LinearOperator implementation to wrap the numerical nuts and bolts of GPyTorch";
    homepage = "https://github.com/cornellius-gp/linear_operator/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
