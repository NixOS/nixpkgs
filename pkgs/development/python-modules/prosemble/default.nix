{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Build
  setuptools,
  setuptools-scm,
  # Runtime
  numpy,
  scikit-learn,
  matplotlib,
  jax,
  jaxlib,
  chex,
  optax,
  # Tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "prosemble";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "naotoo1";
    repo = "prosemble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y/poU2k89Qkw3G1CyGpX1D+O8MeBrs8Afp2J/3ym9y8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scikit-learn
    matplotlib
    jax
    jaxlib
    chex
    optax
  ];

  optional-dependencies = {
    jax = [
      jax
      jaxlib
      chex
      optax
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "prosemble"
    "prosemble.models"
    "prosemble.core"
  ];

  meta = {
    description = "JAX-based prototype machine learning library";
    homepage = "https://github.com/naotoo1/prosemble";
    changelog = "https://github.com/naotoo1/prosemble/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naotoo1 ];
  };
})
