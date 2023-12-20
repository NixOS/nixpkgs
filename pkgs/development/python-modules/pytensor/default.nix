{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, versioneer
, cons
, etuples
, filelock
, logical-unification
, minikanren
, numpy
, scipy
, typing-extensions
, jax
, jaxlib
, numba
, numba-scipy
, pytest-mock
, pytestCheckHook
, pythonOlder
, tensorflow-probability
, stdenv
}:

buildPythonPackage rec {
  pname = "pytensor";
  version = "2.18.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pytensor";
    rev = "refs/tags/rel-${version}";
    hash = "sha256-j7SNXFiQUofP5NtggSOwLxXkg267yneqoWH2uoDZogs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "versioneer[toml]==0.28" "versioneer[toml]"
  '';

  nativeBuildInputs = [
    cython
    versioneer
  ];

  propagatedBuildInputs = [
    cons
    etuples
    filelock
    logical-unification
    minikanren
    numpy
    scipy
    typing-extensions
  ];

  nativeCheckInputs = [
    jax
    jaxlib
    numba
    numba-scipy
    pytest-mock
    pytestCheckHook
    tensorflow-probability
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "pytensor"
  ];

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

  meta = with lib; {
    description = "Python library to define, optimize, and efficiently evaluate mathematical expressions involving multi-dimensional arrays";
    homepage = "https://github.com/pymc-devs/pytensor";
    changelog = "https://github.com/pymc-devs/pytensor/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
