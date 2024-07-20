{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  chex,
  jaxlib,
  numpy,
  tensorflow-probability,
  dm-haiku,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "distrax";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "distrax";
    rev = "refs/tags/v${version}";
    hash = "sha256-A1aCL/I89Blg9sNmIWQru4QJteUTN6+bhgrEJPmCrM0=";
  };

  buildInputs = [
    chex
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
  ];

  meta = with lib; {
    description = "Probability distributions in JAX";
    homepage = "https://github.com/deepmind/distrax";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
    # Several tests fail with:
    # AssertionError: [Chex] Assertion assert_type failed: Error in type compatibility check
    broken = true;
  };
}
