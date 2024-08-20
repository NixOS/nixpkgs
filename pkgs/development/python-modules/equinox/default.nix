{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
  hatchling,
  jax,
  jaxlib,
  jaxtyping,
  typing-extensions,
  beartype,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "equinox";
  version = "0.11.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    rev = "refs/tags/v${version}";
    hash = "sha256-3OwHND1YEdg/SppqiB7pCdp6v+lYwTbtX07tmyEMWDo=";
  };

  patches = [
    # TODO: remove when next release (0.11.5) is out
    (fetchpatch {
      name = "make-tests-pass-with-jaxtyping-0-2-30";
      url = "https://github.com/patrick-kidger/equinox/commit/cf942646cddffd32519d876c653d09e064bd66b8.patch";
      hash = "sha256-q/vbvLhqT4q+BK+q5sPVY5arzXCmH5LWxt4evAwywtM=";
    })
  ];

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
