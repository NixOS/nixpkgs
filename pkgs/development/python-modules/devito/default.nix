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
, pyrevolve
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, scipy
, sympy
}:

buildPythonPackage rec {
  pname = "devito";
  version = "4.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = "devito";
    rev = "refs/tags/v${version}";
    hash = "sha256-zckFU9Q5Rpj0TPeT96lXfR/yp2SYrV4sjAjqN/y8GDw=";
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

  propagatedBuildInputs = [
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
    pyrevolve
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
  ];

  disabledTestPaths = [
    "tests/test_pickle.py"
    "tests/test_benchmark.py"
    "tests/test_mpi.py"
    "tests/test_autotuner.py"
    "tests/test_data.py"
    "tests/test_dse.py"
    "tests/test_gradient.py"
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
