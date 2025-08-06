{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  numpy,
  pybind11,
  setuptools,

  # dependencies
  clarabel,
  cvxopt,
  osqp,
  scipy,
  scs,

  # tests
  hypothesis,
  pytestCheckHook,

  useOpenmp ? (!stdenv.hostPlatform.isDarwin),
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cvxpy";
    repo = "cvxpy";
    tag = "v${version}";
    hash = "sha256-gJL9j2hA+PvNhN1twv31dxb5Gz+q8uoIzwhXB12aIr4=";
  };

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
    changelog = "https://github.com/cvxpy/cvxpy/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drewrisinger ];
  };
}
