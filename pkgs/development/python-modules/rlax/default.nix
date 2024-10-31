{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  absl-py,
  chex,
  distrax,
  dm-env,
  jax,
  jaxlib,
  numpy,
  tensorflow-probability,
  dm-haiku,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rlax";
  version = "0.1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "rlax";
    rev = "refs/tags/v${version}";
    hash = "sha256-v2Lbzya+E9d7tlUVlQQa4fuPp2q3E309Qvyt70mcdb0=";
  };

  patches = [
    (fetchpatch {
      # Follow chex API change (https://github.com/google-deepmind/chex/pull/52)
      name = "replace-deprecated-chex-assertions";
      url = "https://github.com/google-deepmind/rlax/commit/30e7913a1102667137654d6e652a6c4b9e9ba1f4.patch";
      hash = "sha256-OPnuTKEtwZ28hzR1660v3DcktxTYjhR1xYvFbQvOhgs=";
    })
  ];

  propagatedBuildInputs = [
    absl-py
    chex
    distrax
    dm-env
    jax
    jaxlib
    numpy
    tensorflow-probability
  ];

  nativeCheckInputs = [
    dm-haiku
    optax
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rlax" ];

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
