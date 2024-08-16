{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  versioneer,

  # dependencies
  cons,
  etuples,
  filelock,
  logical-unification,
  minikanren,
  numpy,
  scipy,

  # checks
  jax,
  jaxlib,
  numba,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  tensorflow-probability,
}:

buildPythonPackage rec {
  pname = "pytensor";
  version = "2.25.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pytensor";
    rev = "refs/tags/rel-${version}";
    hash = "sha256-+82zQtC20Q2u3/ujnt8UfmK4oYCpH6Eo2TTlk2g3z+s=";
  };

  pythonRelaxDeps = [
    "scipy"
  ];

  build-system = [
    cython
    versioneer
  ];

  dependencies = [
    cons
    etuples
    filelock
    logical-unification
    minikanren
    numpy
    scipy
  ];

  nativeCheckInputs = [
    jax
    jaxlib
    numba
    pytest-mock
    pytestCheckHook
    tensorflow-probability
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "pytensor" ];

  disabledTests = [
    # benchmarks (require pytest-benchmark):
    "test_elemwise_speed"
    "test_fused_elemwise_benchmark"
    "test_logsumexp_benchmark"
    "test_scan_multiple_output"
    "test_vector_taps_benchmark"
  ];

  disabledTestPaths = [
    # Don't run the most compute-intense tests
    "tests/scan/"
    "tests/tensor/"
    "tests/sparse/sandbox/"
  ];

  meta = {
    description = "Python library to define, optimize, and efficiently evaluate mathematical expressions involving multi-dimensional arrays";
    mainProgram = "pytensor-cache";
    homepage = "https://github.com/pymc-devs/pytensor";
    changelog = "https://github.com/pymc-devs/pytensor/releases";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bcdarwin
      ferrine
    ];
  };
}
