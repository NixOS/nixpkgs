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
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C3nFOv/zxvAoz6WZ0RAZffzEbxIx/XrGabO4QPxrik8=";
  };

  buildInputs = [
    chex
    jaxlib
    distrax
    tensorflow-probability
  ];

  nativeCheckInputs = [
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
