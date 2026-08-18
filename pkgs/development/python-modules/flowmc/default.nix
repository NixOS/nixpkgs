{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  chex,
  equinox,
  jax,
  jaxtyping,
  optax,
  scikit-learn,
  tqdm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flowmc";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kazewong";
    repo = "flowMC";
    tag = "flowMC-${finalAttrs.version}";
    hash = "sha256-D3K9cvmUvwsVAjvXdSDgYlqrzTYXVlSVQbfx7TANz8A=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "jax"
  ];

  pythonRemoveDeps = [
    # Not actual runtime dependencies
    "pre-commit"
    "pyright"
    "pytest"
    "ruff"
  ];

  dependencies = [
    chex
    equinox
    jax
    jaxtyping
    optax
    scikit-learn
    tqdm
  ];

  pythonImportsCheck = [ "flowMC" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # ValueError: Expected None, got JitTracer(bool[3,2])
    "test/integration/test_quickstart.py"
  ];

  disabledTests = [
    # ValueError: Expected None, got JitTracer(bool[3,2])
    "test_rqSpline"
    "test_training"
  ];

  meta = {
    description = "Normalizing-flow enhanced sampling package for probabilistic inference in Jax";
    homepage = "https://github.com/kazewong/flowMC";
    changelog = "https://github.com/kazewong/flowMC/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
