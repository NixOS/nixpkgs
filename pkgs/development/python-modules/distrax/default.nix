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
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "distrax";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "distrax";
    tag = "v${version}";
    hash = "sha256-R6rGGNzup3O6eZ2z4vygYWTjroE/Irt3aog8Op+0hco=";
  };

  build-system = [
    flit-core
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
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "distrax" ];

  disabledTests = [
    # Flaky: AssertionError: 1 not less than 0.7000000000000001
    "test_von_mises_sample_uniform_ks_test"

    # Flaky: AssertionError: Not equal to tolerance
    "test_composite_methods_are_consistent__with_jit"

    # NotImplementedError: Primitive 'square' does not have a registered inverse.
    "test_against_tfp_bijectors_square"
    "test_log_dets_square__with_device"
    "test_log_dets_square__without_device"
    "test_log_dets_square__without_jit"

    # AssertionError on numerical values
    # Reported upstream in https://github.com/google-deepmind/distrax/issues/267
    "test_method_with_input_unnormalized_probs__with_device"
    "test_method_with_input_unnormalized_probs__with_jit"
    "test_method_with_input_unnormalized_probs__without_device"
    "test_method_with_input_unnormalized_probs__without_jit"
    "test_method_with_value_1d"
    "test_nested_distributions__with_device"
    "test_nested_distributions__without_device"
    "test_nested_distributions__with_jit"
    "test_nested_distributions__without_jit"
    "test_stability__with_device"
    "test_stability__with_jit"
    "test_stability__without_device"
    "test_stability__without_jit"
    "test_von_mises_sample_gradient"
    "test_von_mises_sample_moments"
  ];

  disabledTestPaths = [
    # Since jax 0.6.0:
    # TypeError: <lambda>() got an unexpected keyword argument 'accuracy'
    "distrax/_src/bijectors/lambda_bijector_test.py"

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
    "distrax/_src/utils/transformations_test.py"
    # https://github.com/google-deepmind/distrax/pull/270
    "distrax/_src/distributions/deterministic_test.py"
    "distrax/_src/distributions/epsilon_greedy_test.py"
    "distrax/_src/distributions/gamma_test.py"
    "distrax/_src/distributions/greedy_test.py"
    "distrax/_src/distributions/gumbel_test.py"
    "distrax/_src/distributions/logistic_test.py"
    "distrax/_src/distributions/log_stddev_normal_test.py"
    "distrax/_src/distributions/mvn_diag_test.py"
    "distrax/_src/distributions/mvn_full_covariance_test.py"
    "distrax/_src/distributions/mvn_tri_test.py"
    "distrax/_src/distributions/one_hot_categorical_test.py"
    "distrax/_src/distributions/softmax_test.py"
    "distrax/_src/utils/hmm_test.py"
  ];

  meta = {
    description = "Probability distributions in JAX";
    homepage = "https://github.com/deepmind/distrax";
    changelog = "https://github.com/google-deepmind/distrax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
    badPlatforms = [
      # SystemError: nanobind::detail::nb_func_error_except(): exception could not be translated!
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
