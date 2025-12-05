{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  anytree,
  cgen,
  cloudpickle,
  codepy,
  llvmPackages,
  multidict,
  numpy,
  packaging,
  psutil,
  py-cpuinfo,
  sympy,

  # tests
  click,
  gcc,
  matplotlib,
  pytest-xdist,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "devito";
  version = "4.8.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = "devito";
    tag = "v${version}";
    hash = "sha256-kE4u5r2GFe4Y+IdSEnNZEOAO9WoSIM00Ify1eLaflWI=";
  };

  pythonRemoveDeps = [ "pip" ];

  pythonRelaxDeps = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    anytree
    cgen
    cloudpickle
    codepy
    multidict
    numpy
    packaging
    psutil
    py-cpuinfo
    sympy
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  nativeCheckInputs = [
    click
    gcc
    matplotlib
    pytest-xdist
    pytestCheckHook
    scipy
  ];

  pytestFlags = [
    "-x"
  ];

  disabledTestMarks = [
    # Tests marked as 'parallel' require mpi and fail in the sandbox:
    # FileNotFoundError: [Errno 2] No such file or directory: 'mpiexec'
    "parallel"
  ];

  disabledTests = [
    # Download dataset from the internet
    "test_gs_2d_float"
    "test_gs_2d_int"
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

    # AssertionError: assert(np.allclose(grad_u.data, grad_v.data, rtol=tolerance, atol=tolerance))
    "test_gradient_equivalence"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Numerical tests
    "test_lm_fb"
    "test_lm_ds"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Numerical error
    "test_pow_precision"
  ];

  disabledTestPaths =
    lib.optionals
      ((stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin)
      [
        # Flaky: codepy.CompileError: module compilation failed
        "tests/test_dse.py"
      ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # assert np.all(f.data == check)
      # assert Data(False)
      "tests/test_data.py::TestDataReference::test_w_data"

      # AssertionError: assert 'omp for schedule(dynamic,1)' == 'omp for coll...le(dynamic,1)'
      "tests/test_dle.py::TestNestedParallelism::test_nested_cache_blocking_structure_subdims"

      # codepy.CompileError: module compilation failed
      # FAILED compiler invocation
      "tests/test_dle.py::TestNodeParallelism::test_dynamic_nthreads"

      # AssertionError: assert all(not i.pragmas for i in iters[2:])
      "tests/test_dle.py::TestNodeParallelism::test_incr_perfect_sparse_outer"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # IndexError: tuple index out of range
      "tests/test_dle.py::TestNestedParallelism"

      # codepy.CompileError: module compilation failed
      "tests/test_autotuner.py::test_nested_nthreads"

      # assert np.all(np.isclose(f0.data, check0))
      # assert Data(false)
      "tests/test_interpolation.py::TestSubDomainInterpolation::test_inject_subdomain"
    ];

  pythonImportsCheck = [ "devito" ];

  meta = {
    description = "Code generation framework for automated finite difference computation";
    homepage = "https://www.devitoproject.org/";
    changelog = "https://github.com/devitocodes/devito/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atila ];
  };
}
