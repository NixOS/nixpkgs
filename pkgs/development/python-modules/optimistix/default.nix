{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  equinox,
  jax,
  jaxtyping,
  lineax,
  typing-extensions,

  # tests
  beartype,
  jaxlib,
  optax,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "optimistix";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "optimistix";
    tag = "v${version}";
    hash = "sha256-tTE/f1dYDpTmrqL1D7h7UyqT2gN9+Y1mNJZcjmdHtno=";
  };

  build-system = [ hatchling ];

  dependencies = [
    equinox
    jax
    jaxtyping
    lineax
    typing-extensions
  ];

  pythonImportsCheck = [ "optimistix" ];

  nativeCheckInputs = [
    beartype
    jaxlib
    optax
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    # assert Array(False, dtype=bool)
    # +  where Array(False, dtype=bool) = tree_allclose(Array(0.12993518, dtype=float64), Array(0., dtype=float64, weak_type=True), atol=0.0001, rtol=0.0001)
    "test_least_squares"
  ];

  disabledTestPaths = [
    # Require circular dependency diffrax
    "tests/test_compat.py"
    "tests/test_fixed_point.py"
    "tests/test_lbfgs_linear_operator.py"
    "tests/test_least_squares.py"
    "tests/test_minimise.py"
    "tests/test_misc.py"
    "tests/test_root_find.py"
  ];

  meta = {
    description = "Nonlinear optimisation (root-finding, least squares, ...) in JAX+Equinox";
    homepage = "https://github.com/patrick-kidger/optimistix";
    changelog = "https://github.com/patrick-kidger/optimistix/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
