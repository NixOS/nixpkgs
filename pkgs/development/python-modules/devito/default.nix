{ lib
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
, scipy
, stdenv
, sympy
}:

buildPythonPackage rec {
  pname = "devito";
  version = "4.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = "devito";
    rev = "refs/tags/v${version}";
    hash = "sha256-crKTxlueE8NGjAqu625iFvp35UK2U7+9kl8rpbzf0gs=";
  };

  postPatch = ''
    # Removing unecessary dependencies
    sed -e "s/flake8.*//g" \
        -e "s/codecov.*//g" \
        -e "s/pytest.*//g" \
        -e "s/pytest-runner.*//g" \
        -e "s/pytest-cov.*//g" \
        -i requirements.txt

    # Relaxing dependencies requirements
    sed -e "s/>.*//g" \
        -e "s/<.*//g" \
        -i requirements.txt
  '';

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
    pytestCheckHook
    pytest-xdist
    matplotlib
    gcc
  ];

  # I've had to disable the following tests since they fail while using nix-build, but they do pass
  # outside the build. They mostly related to the usage of MPI in a sandboxed environment.
  disabledTests = [
    "test_assign_parallel"
    "test_gs_parallel"
    "test_if_parallel"
    "test_if_halo_mpi"
    "test_cache_blocking_structure_distributed"
    "test_mpi"
    "test_codegen_quality0"
    "test_new_distributor"
    "test_subdomainset_mpi"
    "test_init_omp_env_w_mpi"
    "test_mpi_nocomms"
    "test_shortcuts"
    "est_docstrings"
    "test_docstrings[finite_differences.coefficients]"
    "test_coefficients_w_xreplace"
    "test_loop_bounds_forward"
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
