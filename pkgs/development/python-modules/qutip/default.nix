{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython_0,
  oldest-supported-numpy,
  setuptools,

  # dependencies
  numpy,
  packaging,
  scipy,

  # tests
  pytestCheckHook,
  pytest-rerunfailures,
  python,

  # optional-dependencies
  matplotlib,
  ipython,
  cvxopt,
  cvxpy,
}:

buildPythonPackage rec {
  pname = "qutip";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qutip";
    repo = "qutip";
    tag = "v${version}";
    hash = "sha256-8P95uAalMeGXWNG8J8Rf/eg0x1K62o9rKjmDrB8KGRo=";
  };

  postPatch = ''
    # build-time constriant, used to ensure forward and backward compat
    substituteInPlace pyproject.toml setup.cfg \
      --replace-fail "numpy>=2.0.0" "numpy"
  '';

  build-system = [
    cython_0
    oldest-supported-numpy
    setuptools
  ];

  dependencies = [
    numpy
    packaging
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  # QuTiP tries to access the home directory to create an rc file for us.
  # We need to go to another directory to run the tests from there.
  # This is due to the Cython-compiled modules not being in the correct location
  # of the source tree.
  preCheck = ''
    export HOME=$(mktemp -d);
    export OMP_NUM_THREADS=$NIX_BUILD_CORES
    mkdir -p test && cd test
  '';

  # For running tests, see https://qutip.org/docs/latest/installation.html#verifying-the-installation
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -c "import qutip.testing; qutip.testing.run()"
    runHook postCheck
  '';

  pythonImportsCheck = [ "qutip" ];

  pytestFlagsArray = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Aborted
    "--deselect=../tests/core/test_metrics.py::Test_hellinger_dist::test_monotonicity[25]"
  ];

  optional-dependencies = {
    graphics = [ matplotlib ];
    ipython = [ ipython ];
    semidefinite = [
      cvxopt
      cvxpy
    ];
  };

  meta = {
    description = "Open-source software for simulating the dynamics of closed and open quantum systems";
    homepage = "https://qutip.org/";
    changelog = "https://github.com/qutip/qutip/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fabiangd ];
    badPlatforms = [
      # Tests fail at ~80%
      # ../tests/test_animation.py::test_result_state Fatal Python error: Aborted
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
