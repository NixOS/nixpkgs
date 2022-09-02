{ lib
, fetchPypi
, buildPythonPackage
, chex
, jaxlib
, tensorflow-probability
, optax
, dm-haiku
, bsuite
, frozendict
, pytestCheckHook
, dm-env
, distrax }:

buildPythonPackage rec {
  pname = "rlax";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hAG0idz5VkGVvxaJWoxlVZ8myeHF6ndDxB0SyJm7qV8=";
  };

  buildInputs = [
    chex
    jaxlib
    distrax
    tensorflow-probability
  ];

  checkInputs = [
    bsuite
    dm-env
    dm-haiku
    frozendict
    optax
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rlax"
  ];

  disabledTests = [
    # RuntimeErrors
    "test_cross_replica_scatter_add0"
    "test_cross_replica_scatter_add1"
    "test_cross_replica_scatter_add2"
    "test_cross_replica_scatter_add3"
    "test_cross_replica_scatter_add4"
    "test_learn_scale_shift"
    "test_normalize_unnormalize_is_identity"
    "test_outputs_preserved"
    "test_scale_bounded"
    "test_slow_update"
    "test_unnormalize_linear"
  ];

  meta = with lib; {
    description = "Library of reinforcement learning building blocks in JAX";
    homepage = "https://github.com/deepmind/rlax";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
