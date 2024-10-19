{
  lib,
  stdenv,
  anytree,
  buildPythonPackage,
  setuptools,
  cached-property,
  cgen,
  click,
  codepy,
  distributed,
  fetchFromGitHub,
  gcc,
  llvmPackages,
  matplotlib,
  multidict,
  nbval,
  psutil,
  py-cpuinfo,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  scipy,
  sympy,
}:

buildPythonPackage rec {
  pname = "devito";
  version = "4.8.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = "devito";
    rev = "refs/tags/v${version}";
    hash = "sha256-c8/b2dRwfH4naSVRaRon6/mBDva7RSDmi/TJUJp26g0=";
  };

  # packaging.metadata.InvalidMetadata: 'python_version_3.8_' is invalid for 'provides-extra'
  postPatch = ''
    substituteInPlace requirements-testing.txt \
      --replace-fail 'pooch; python_version >= "3.8"' "pooch"
  '';

  pythonRemoveDeps = [ "pip" ];

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

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
  ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  nativeCheckInputs = [
    gcc
    matplotlib
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-x" ];

  # I've had to disable the following tests since they fail while using nix-build, but they do pass
  # outside the build. They mostly related to the usage of MPI in a sandboxed environment.
  disabledTests =
    [
      "test_assign_parallel"
      "test_cache_blocking_structure_distributed"
      "test_codegen_quality0"
      "test_coefficients_w_xreplace"
      "test_docstrings"
      "test_docstrings[finite_differences.coefficients]"
      "test_gs_parallel"
      "test_if_halo_mpi"
      "test_if_parallel"
      "test_index_derivative"
      "test_init_omp_env_w_mpi"
      "test_loop_bounds_forward"
      "test_min_max_mpi"
      "test_mpi"
      "test_mpi_nocomms"
      "test_new_distributor"
      "test_setupWOverQ"
      "test_shortcuts"
      "test_stability_mpi"
      "test_subdomainset_mpi"
      "test_subdomains_mpi"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # FAILED tests/test_unexpansion.py::Test2Pass::test_v0 - assert False
      "test_v0"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # FAILED tests/test_caching.py::TestCaching::test_special_symbols - ValueError: not enough values to unpack (expected 3, got 2)
      "test_special_symbols"

      # FAILED tests/test_unexpansion.py::Test2Pass::test_v0 - codepy.CompileError: module compilation failed
      "test_v0"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # Numerical tests
      "test_lm_fb"
      "test_lm_ds"
    ];

  disabledTestPaths =
    [
      "tests/test_pickle.py"
      "tests/test_benchmark.py"
      "tests/test_mpi.py"
      "tests/test_autotuner.py"
      "tests/test_data.py"
      "tests/test_dse.py"
      "tests/test_gradient.py"
    ]
    ++ lib.optionals (
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin
    ) [ "tests/test_dle.py" ];

  pythonImportsCheck = [ "devito" ];

  meta = {
    description = "Code generation framework for automated finite difference computation";
    homepage = "https://www.devitoproject.org/";
    changelog = "https://github.com/devitocodes/devito/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atila ];
  };
}
