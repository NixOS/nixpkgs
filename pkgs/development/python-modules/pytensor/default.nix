{
  lib,
  stdenv,
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

  # tests
  jax,
  jaxlib,
  numba,
  pytest-benchmark,
  pytest-mock,
  pytestCheckHook,
  tensorflow-probability,
  writableTmpDirAsHomeHook,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pytensor";
  version = "2.28.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = "pytensor";
    tag = "rel-${version}";
    hash = "sha256-MtY0JbziboJNHKe8wXaPtOWgFnpv8yQZeg6hNirnSEI=";
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
    pytest-benchmark
    pytest-mock
    pytestCheckHook
    tensorflow-probability
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pytensor" ];

  # Ensure that the installed package is used instead of the source files from the current workdir
  preCheck = ''
    rm -rf pytensor
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # pytensor.link.c.exceptions.CompileError: Compilation failed (return status=1)
    "OpFromGraph"
    "add"
    "cls_ofg1"
    "direct"
    "multiply"
    "test_AddDS"
    "test_AddSD"
    "test_AddSS"
    "test_MulDS"
    "test_MulSD"
    "test_MulSS"
    "test_NoOutputFromInplace"
    "test_OpFromGraph"
    "test_adv_sub1_sparse_grad"
    "test_alloc"
    "test_binary"
    "test_borrow_input"
    "test_borrow_output"
    "test_cache_race_condition"
    "test_check_for_aliased_inputs"
    "test_clinker_literal_cache"
    "test_csm_grad"
    "test_csm_unsorted"
    "test_csr_dense_grad"
    "test_debugprint"
    "test_ellipsis_einsum"
    "test_empty_elemwise"
    "test_flatten"
    "test_fprop"
    "test_get_item_list_grad"
    "test_grad"
    "test_infer_shape"
    "test_jax_pad"
    "test_kron"
    "test_masked_input"
    "test_max"
    "test_modes"
    "test_mul_s_v_grad"
    "test_multiple_outputs"
    "test_not_inplace"
    "test_numba_Cholesky_grad"
    "test_numba_pad"
    "test_optimizations_preserved"
    "test_overided_function"
    "test_potential_output_aliasing_induced_by_updates"
    "test_profiling"
    "test_rebuild_strict"
    "test_runtime_broadcast_c"
    "test_scan_err1"
    "test_scan_err2"
    "test_shared"
    "test_solve_triangular_grad"
    "test_structured_add_s_v_grad"
    "test_structureddot_csc_grad"
    "test_structureddot_csr_grad"
    "test_sum"
    "test_swap_SharedVariable_with_given"
    "test_test_value_op"
    "test_unary"
    "test_unbroadcast"
    "test_update_equiv"
    "test_update_same"
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
    changelog = "https://github.com/pymc-devs/pytensor/releases/tag/red-${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bcdarwin
      ferrine
    ];
  };
}
