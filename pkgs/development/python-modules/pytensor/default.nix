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
  pytestCheckHook,
  pytest-mock,
  tensorflow-probability,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pytensor";
  version = "2.26.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pytensor";
    rev = "refs/tags/rel-${version}";
    hash = "sha256-RhicZSVkaDtIngIOvzyEQ+VMZwdV45wDk7e7bThTIh8=";
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
    pytestCheckHook
    pytest-mock
    tensorflow-probability
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "pytensor" ];

  # Ensure that the installed package is used instead of the source files from the current workdir
  preCheck = ''
    rm -rf pytensor
  '';

  disabledTests = [
    # benchmarks (require pytest-benchmark):
    "test_elemwise_speed"
    "test_fused_elemwise_benchmark"
    "test_logsumexp_benchmark"
    "test_minimal_random_function_call_benchmark"
    "test_scan_multiple_output"
    "test_vector_taps_benchmark"

    # Failure reported upstream: https://github.com/pymc-devs/pytensor/issues/980
    "test_choose_signature"
  ];

  disabledTestPaths = [
    # Don't run the most compute-intense tests
    "tests/scan/"
    "tests/tensor/"
    "tests/sparse/sandbox/"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "rel-(.+)"
    ];
  };

  meta = {
    description = "Python library to define, optimize, and efficiently evaluate mathematical expressions involving multi-dimensional arrays";
    mainProgram = "pytensor-cache";
    homepage = "https://github.com/pymc-devs/pytensor";
    changelog = "https://github.com/pymc-devs/pytensor/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bcdarwin
      ferrine
    ];
  };
}
