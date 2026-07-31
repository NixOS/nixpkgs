{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  absl-py,
  chex,
  jax,
  jaxlib,
  numpy,
  tensorflow-probability,

  # tests
  dm-haiku,
  mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "distrax";
  version = "0.1.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "distrax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mX05qWyGTye+ZIXzU+W8ICz691UgVNIYXFN7oJHPssc=";
  };

  build-system = [
    flit-core
  ];

  pythonRemoveDeps = [
    "tfp-nightly"
  ];
  dependencies = [
    absl-py
    chex
    jax
    jaxlib
    numpy
    tensorflow-probability
  ];

  nativeCheckInputs = [
    dm-haiku
    mock
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "distrax" ];

  disabledTests = [
    # Flaky: AssertionError: 1 not less than 0.7000000000000001
    "test_von_mises_sample_gradient"
    "test_von_mises_sample_moments"
    "test_von_mises_sample_uniform_ks_test"

    # Flaky: AssertionError: Not equal to tolerance
    "StraightThroughTest"
    "test_composite_methods_are_consistent__with_jit"
  ];

  disabledTestPaths = [
    # TypeErrors
    "distrax/_src/bijectors/tfp_compatible_bijector_test.py"
    "distrax/_src/distributions/distribution_from_tfp_test.py"
    "distrax/_src/distributions/laplace_test.py"
    "distrax/_src/distributions/multinomial_test.py"
    "distrax/_src/distributions/mvn_diag_plus_low_rank_test.py"
    "distrax/_src/distributions/mvn_kl_test.py"
    "distrax/_src/distributions/straight_through_test.py"
    "distrax/_src/distributions/tfp_compatible_distribution_test.py"
    "distrax/_src/distributions/transformed_test.py"
    "distrax/_src/distributions/uniform_test.py"
    "distrax/_src/utils/hmm_test.py"
    "distrax/_src/utils/transformations_test.py"
  ];

  meta = {
    description = "Probability distributions in JAX";
    homepage = "https://github.com/deepmind/distrax";
    changelog = "https://github.com/google-deepmind/distrax/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
})
