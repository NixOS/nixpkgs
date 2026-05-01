{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  numpy,
  pybind11,
  setuptools,

  # dependencies
  clarabel,
  cvxopt,
  highspy,
  osqp,
  scipy,
  scs,

  # tests
  hypothesis,
  pytestCheckHook,

  useOpenmp ? (!stdenv.hostPlatform.isDarwin),
}:

buildPythonPackage (finalAttrs: {
  pname = "cvxpy";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cvxpy";
    repo = "cvxpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MDKTuiePzqdIJlTRxbCOxoaEAisGx368iWbwKEB97QU=";
  };

  patches = [
    # Upstream PR: https://github.com/cvxpy/cvxpy/pull/3290
    (fetchpatch {
      name = "highs-1.14.0.patch";
      url = "https://github.com/cvxpy/cvxpy/commit/89f8d337d927457c2e308de8295dd83f274e40e7.patch";
      hash = "sha256-BO878Kz5ZH5FHkxZugzT+n6wjsoOReqCZWM2HDvFqAw=";
    })
  ];

  postPatch =
    # too tight tolerance in tests (AssertionError)
    ''
      substituteInPlace cvxpy/tests/test_constant_atoms.py \
        --replace-fail \
          "CLARABEL: 1e-7," \
          "CLARABEL: 1e-6,"
    '';

  build-system = [
    numpy
    pybind11
    setuptools
  ];

  dependencies = [
    clarabel
    cvxopt
    highspy
    numpy
    osqp
    scipy
    scs
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # Required flags from https://github.com/cvxpy/cvxpy/releases/tag/v1.1.11
  preBuild = lib.optionalString useOpenmp ''
    export CFLAGS="-fopenmp"
    export LDFLAGS="-lgomp"
  '';

  enabledTestPaths = [ "cvxpy" ];

  disabledTests = [
    # Disable the slowest benchmarking tests, cuts test time in half
    "test_tv_inpainting"
    "test_diffcp_sdp_example"
    "test_huber"
    "test_partial_problem"

    # cvxpy.error.SolverError: Solver 'CVXOPT' failed. Try another solver, or solve with verbose=True for more information.
    # https://github.com/cvxpy/cvxpy/issues/1588
    "test_oprelcone_1_m1_k3_complex"
    "test_oprelcone_1_m3_k1_complex"
    "test_oprelcone_2"
  ];

  pythonImportsCheck = [ "cvxpy" ];

  meta = {
    description = "Domain-specific language for modeling convex optimization problems in Python";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxpy/cvxpy//releases";
    changelog = "https://github.com/cvxpy/cvxpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.GaetanLepage ];
  };
})
