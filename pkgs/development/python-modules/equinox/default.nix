{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  jax,
  jaxlib,
  jaxtyping,
  typing-extensions,

  # checks
  beartype,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "equinox";
  version = "0.11.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    tag = "v${version}";
    hash = "sha256-QoqwLdtWCDrXyqiI6Xw7jq2sxiRCmLaxk3/ZGHrvqL4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jax
    jaxlib
    jaxtyping
    typing-extensions
  ];

  nativeCheckInputs = [
    beartype
    optax
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "equinox" ];

  meta = {
    description = "JAX library based around a simple idea: represent parameterised functions (such as neural networks) as PyTrees";
    changelog = "https://github.com/patrick-kidger/equinox/releases/tag/v${version}";
    homepage = "https://github.com/patrick-kidger/equinox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
