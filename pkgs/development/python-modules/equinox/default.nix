{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  version = "0.11.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    rev = "refs/tags/v${version}";
    hash = "sha256-r4HKn+WJmC7BrTeDDAQ1++TpQhhtLcK6HL2CoM/MGx8=";
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

  disabledTests = [
    # For simplicity, JAX has removed its internal frames from the traceback of the following exception.
    # https://github.com/patrick-kidger/equinox/issues/716
    "test_abstract"
    "test_complicated"
    "test_grad"
    "test_jvp"
    "test_mlp"
    "test_num_traces"
    "test_pytree_in"
    "test_simple"
    "test_vmap"

    # AssertionError: assert 'foo:\n   pri...pe=float32)\n' == 'foo:\n   pri...pe=float32)\n'
    # Also reported in patrick-kidger/equinox#716
    "test_backward_nan"

    # Flaky test
    # See https://github.com/patrick-kidger/equinox/issues/781
    "test_traceback_runtime_eqx"
  ];

  meta = {
    description = "JAX library based around a simple idea: represent parameterised functions (such as neural networks) as PyTrees";
    changelog = "https://github.com/patrick-kidger/equinox/releases/tag/v${version}";
    homepage = "https://github.com/patrick-kidger/equinox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
