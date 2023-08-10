{ lib
, stdenv
, buildPythonPackage
, cons
, cython
, etuples
, fetchFromGitHub
, filelock
, hatch-vcs
, hatchling
, jax
, jaxlib
, logical-unification
, minikanren
, numba
, numba-scipy
, numpy
, pytestCheckHook
, pythonOlder
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aesara";
  version = "2.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = "aesara";
    rev = "refs/tags/rel-${version}";
    hash = "sha256-eanFkEiuPzm4InLd9dFmoLs/IOofObn9NIzaqzINdMQ=";
  };

  nativeBuildInputs = [
    cython
    hatch-vcs
    hatchling
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
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--durations=50" ""
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "aesara"
  ];

  disabledTestPaths = [
    # Don't run the most compute-intense tests
    "tests/scan/"
    "tests/tensor/"
    "tests/sandbox/"
    "tests/sparse/sandbox/"
    # JAX is not available on all platform and often broken
    "tests/link/jax/"
  ];

  disabledTests = [
    # Disable all benchmark tests
    "test_scan_multiple_output"
    "test_logsumexp_benchmark"
  ];

  meta = with lib; {
    description = "Python library to define, optimize, and efficiently evaluate mathematical expressions involving multi-dimensional arrays";
    homepage = "https://github.com/aesara-devs/aesara";
    changelog = "https://github.com/aesara-devs/aesara/releases/tag/rel-${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Etjean ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
