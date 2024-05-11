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
, pythonAtLeast
, pythonOlder
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aesara";
  version = "2.9.3";
  pyproject = true;

  # Python 3.12 is not supported: https://github.com/aesara-devs/aesara/issues/1520
  disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = "aesara";
    rev = "refs/tags/rel-${version}";
    hash = "sha256-aO0+O7Ts9phsV4ghunNolxfAruGBbC+tHjVkmFedcCI=";
  };

  build-system = [
    cython
    hatch-vcs
    hatchling
  ];

  dependencies = [
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
      --replace-fail "--durations=50" "" \
      --replace-fail "hatch-vcs >=0.3.0,<0.4.0" "hatch-vcs"
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

    # 2024-04-27: The current nixpkgs numba version is too recent and incompatible with aesara 2.9.3
    "tests/link/numba/"
  ];

  disabledTests = [
    # Disable all benchmark tests
    "test_scan_multiple_output"
    "test_logsumexp_benchmark"

    # TypeError: exceptions must be derived from Warning, not <class 'NoneType'>
    "test_api_deprecation_warning"
    # AssertionError: assert ['Elemwise{Co..._i{0} 0', ...] == ['Elemwise{Co..._i{0} 0', ...]
    # At index 3 diff: '| |Gemv{inplace} d={0: [0]} 2' != '| |CGemv{inplace} d={0: [0]} 2'
    "test_debugprint"
    # ValueError: too many values to unpack (expected 3)
    "test_ExternalCOp_c_code_cache_version"
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
