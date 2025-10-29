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
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = "linear_operator";
    tag = "v${version}";
    hash = "sha256-qBC7wrpcZ8ViFqIOSd2F8heeBRQxrac/l33srHhNaIM=";
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

  meta = with lib; {
    description = "LinearOperator implementation to wrap the numerical nuts and bolts of GPyTorch";
    homepage = "https://github.com/cornellius-gp/linear_operator/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
