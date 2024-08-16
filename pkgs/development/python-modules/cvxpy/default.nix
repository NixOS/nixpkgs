{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  numpy,
  pybind11,
  setuptools,

  # dependencies
  clarabel,
  cvxopt,
  ecos,
  osqp,
  scipy,
  scs,

  # checks
  pytestCheckHook,

  useOpenmp ? (!stdenv.isDarwin),
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cvxpy";
    repo = "cvxpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-g4JVgykGNFT4ZEi5f8hkVjd7eUVJ+LxvPvmiVa86r1Y=";
  };

  patches = [
    # Fix invalid uses of the scipy library
    # https://github.com/cvxpy/cvxpy/pull/2508
    (fetchpatch {
      name = "scipy-1-14-compat";
      url = "https://github.com/cvxpy/cvxpy/pull/2508/commits/c343f4381c69f7e6b51a86b3eee8b42fbdda9d6a.patch";
      hash = "sha256-SqIdPs9K+GuCLCEJMHUQ+QGWNH5B3tKuwr46tD9Ao2k=";
    })
  ];

  # we need to patch out numpy version caps from upstream
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy >= 2.0.0" "numpy"
  '';

  build-system = [
    numpy
    pybind11
    setuptools
  ];

  dependencies = [
    clarabel
    cvxopt
    ecos
    numpy
    osqp
    scipy
    scs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Required flags from https://github.com/cvxpy/cvxpy/releases/tag/v1.1.11
  preBuild = lib.optionalString useOpenmp ''
    export CFLAGS="-fopenmp"
    export LDFLAGS="-lgomp"
  '';

  pytestFlagsArray = [ "cvxpy" ];

  disabledTests =
    [
      # Disable the slowest benchmarking tests, cuts test time in half
      "test_tv_inpainting"
      "test_diffcp_sdp_example"
      "test_huber"
      "test_partial_problem"
      # https://github.com/cvxpy/cvxpy/issues/2174
      "test_scipy_mi_time_limit_reached"
    ]
    ++ lib.optionals stdenv.isAarch64 [
      "test_ecos_bb_mi_lp_2" # https://github.com/cvxpy/cvxpy/issues/1241#issuecomment-780912155
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
