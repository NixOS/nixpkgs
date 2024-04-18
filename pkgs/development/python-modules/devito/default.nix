{ lib
, stdenv
, anytree
, buildPythonPackage
, cached-property
, cgen
, click
, codepy
, distributed
, fetchFromGitHub
, gcc
, llvmPackages
, matplotlib
, multidict
, nbval
, psutil
, py-cpuinfo
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, scipy
, sympy
}:

buildPythonPackage rec {
  pname = "devito";
  version = "4.8.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = "devito";
    rev = "refs/tags/v${version}";
    hash = "sha256-unuJLp+zTyGpOk5O78xYbW6Zrzp60WyqgT9mf2YpTG4=";
  };

  pythonRemoveDeps = [
    "codecov"
    "flake8"
    "pytest-runner"
    "pytest-cov"
  ];

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  dependencies = [
    anytree
    cached-property
    cgen
    click
    codepy
    distributed
    nbval
    multidict
    psutil
    py-cpuinfo
    scipy
    sympy
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  nativeCheckInputs = [
    gcc
    matplotlib
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-x" ];

  # I've had to disable the following tests since they fail while using nix-build, but they do pass
  # outside the build. They mostly related to the usage of MPI in a sandboxed environment.
  disabledTests = [
    "test_assign_parallel"
    "test_cache_blocking_structure_distributed"
    "test_codegen_quality0"
    "test_coefficients_w_xreplace"
    "test_docstrings"
    "test_docstrings[finite_differences.coefficients]"
    "test_gs_parallel"
    "test_if_halo_mpi"
    "test_if_parallel"
    "test_init_omp_env_w_mpi"
    "test_loop_bounds_forward"
    "test_mpi_nocomms"
    "test_mpi"
    "test_index_derivative"
    "test_new_distributor"
    "test_setupWOverQ"
    "test_shortcuts"
    "test_subdomainset_mpi"
    "test_subdomains_mpi"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # FAILED tests/test_unexpansion.py::Test2Pass::test_v0 - assert False
    "test_v0"
  ] ++ lib.optionals stdenv.isDarwin [
    # FAILED tests/test_caching.py::TestCaching::test_special_symbols - ValueError: not enough values to unpack (expected 3, got 2)
    "test_special_symbols"

    # FAILED tests/test_unexpansion.py::Test2Pass::test_v0 - codepy.CompileError: module compilation failed
    "test_v0"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Numerical tests
    "test_lm_fb"
    "test_lm_ds"
  ];

  disabledTestPaths = [
    "tests/test_pickle.py"
    "tests/test_benchmark.py"
    "tests/test_mpi.py"
    "tests/test_autotuner.py"
    "tests/test_data.py"
    "tests/test_dse.py"
    "tests/test_gradient.py"
  ] ++ lib.optionals ((stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin) [
    "tests/test_dle.py"
  ];

  pythonImportsCheck = [
    "devito"
  ];

  meta = with lib; {
    description = "Code generation framework for automated finite difference computation";
    homepage = "https://www.devitoproject.org/";
    changelog = "https://github.com/devitocodes/devito/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ atila ];
  };
}
