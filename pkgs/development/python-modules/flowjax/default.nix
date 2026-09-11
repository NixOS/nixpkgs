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
  optax,
  paramax,
  tqdm,

  # tests
  beartype,
  numpyro,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flowjax";
  version = "18.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielward27";
    repo = "flowjax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c7KuU5SQe3NIkcYCRHJXk2dkAWUXp6l37nci5qX1s38=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    equinox
    jax
    jaxtyping
    optax
    paramax
    tqdm
  ];

  pythonImportsCheck = [ "flowjax" ];

  nativeCheckInputs = [
    beartype
    numpyro
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    description = "Distributions, bijections and normalizing flows using Equinox and JAX";
    homepage = "https://github.com/danielward27/flowjax";
    changelog = "https://github.com/danielward27/flowjax/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
