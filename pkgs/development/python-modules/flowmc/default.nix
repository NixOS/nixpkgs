{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  chex,
  coveralls,
  equinox,
  jax,
  jaxtyping,
  optax,
  scikit-learn,
  tqdm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flowmc";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kazewong";
    repo = "flowMC";
    tag = "flowMC-${version}";
    hash = "sha256-ambi2BMFjWAggeJ3PdlRpdKVmZeePe5LbvuKzCgNV/k=";
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
    coveralls
    equinox
    jax
    jaxtyping
    optax
    scikit-learn
    tqdm
  ];

  pythonImportsCheck = [ "flowMC" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Normalizing-flow enhanced sampling package for probabilistic inference in Jax";
    homepage = "https://github.com/kazewong/flowMC";
    changelog = "https://github.com/kazewong/flowMC/releases/tag/flowMC-${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
