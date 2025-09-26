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
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "optimistix";
    tag = "v${version}";
    hash = "sha256-stVPHzv0XNd0I31N2Cj0QYrMmhImyx0cablqZfKBFrM=";
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

  pytestFlags = [
    # Since jax 0.5.3:
    # DeprecationWarning: shape requires ndarray or scalar arguments, got <class 'jax._src.api.ShapeDtypeStruct'> at position 0. In a future JAX release this will be an error.
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # assert Array(False, dtype=bool)
    # +  where Array(False, dtype=bool) = tree_allclose(Array(0.12993518, dtype=float64), Array(0., dtype=float64, weak_type=True), atol=0.0001, rtol=0.0001)
    "test_least_squares"
  ];

  meta = {
    description = "Nonlinear optimisation (root-finding, least squares, ...) in JAX+Equinox";
    homepage = "https://github.com/patrick-kidger/optimistix";
    changelog = "https://github.com/patrick-kidger/optimistix/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
