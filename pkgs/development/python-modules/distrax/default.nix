{ lib
, fetchPypi
, buildPythonPackage
, numpy
, tensorflow-probability
, chex
, dm-haiku
, pytestCheckHook
, jaxlib
}:

buildPythonPackage rec {
  pname = "distrax";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x9ORfhGX5catEZMfR+iXkZSRa/wIb0B3CrCWOWf35Ks=";
  };

  buildInputs = [
    chex
    jaxlib
    numpy
    tensorflow-probability
  ];

  nativeCheckInputs = [
    dm-haiku
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "distrax"
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
    # Broken on all platforms (starting 2022-07-27)
    broken = true;
  };
}
