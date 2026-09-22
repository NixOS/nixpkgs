{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cvxpy,
  numpy,
  pandas,
  scipy,
  matplotlib,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pepit";
  version = "0.5.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PerformanceEstimation";
    repo = "PEPit";
    tag = finalAttrs.version;
    hash = "sha256-PCWYfJ1h4P0X4KLNdIivLrPVAR7205K1Ii5ROuGHULo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${finalAttrs.version}"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cvxpy
    numpy
    pandas
    scipy
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Fail since scs 3.3.0, which returns `optimal_inaccurate` where it used to return `optimal`.
  disabledTests = [
    "test_cyclic_coordinate_descent"
    "test_gradient_descent_lc"
    "test_inexact_gradient"
  ];

  pythonImportsCheck = [ "PEPit" ];

  meta = {
    description = "Performance Estimation in Python";
    changelog = "https://pepit.readthedocs.io/en/latest/whatsnew/${finalAttrs.version}.html";
    homepage = "https://pepit.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
})
