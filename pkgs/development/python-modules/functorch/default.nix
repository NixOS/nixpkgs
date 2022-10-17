{ buildPythonPackage
, expecttest
, fetchFromGitHub
, lib
, ninja
, pytestCheckHook
, python
, torch
, pybind11
, which
}:

buildPythonPackage rec {
  pname = "functorch";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-33skKk5aAIHn+1149ifolXPA+tpQ+WROAZvwPeGBbrA=";
  };

  # Somewhat surprisingly pytorch is actually necessary for the build process.
  # `setup.py` imports `torch.utils.cpp_extension`.
  nativeBuildInputs = [
    ninja
    torch
    which
  ];

  buildInputs = [
    pybind11
  ];

  preCheck = ''
    rm -rf functorch/
  '';

  checkInputs = [
    expecttest
    pytestCheckHook
  ];

  # See https://github.com/pytorch/functorch/issues/835.
  disabledTests = [
    # RuntimeError: ("('...', '') is in PyTorch's OpInfo db ", "but is not in functorch's OpInfo db. Please regenerate ", '... and add the new tests to ', 'denylists if necessary.')
    "test_coverage_bernoulli_cpu_float32"
    "test_coverage_column_stack_cpu_float32"
    "test_coverage_diagflat_cpu_float32"
    "test_coverage_flatten_cpu_float32"
    "test_coverage_linalg_lu_factor_cpu_float32"
    "test_coverage_linalg_lu_factor_ex_cpu_float32"
    "test_coverage_multinomial_cpu_float32"
    "test_coverage_nn_functional_dropout2d_cpu_float32"
    "test_coverage_nn_functional_feature_alpha_dropout_with_train_cpu_float32"
    "test_coverage_nn_functional_feature_alpha_dropout_without_train_cpu_float32"
    "test_coverage_nn_functional_kl_div_cpu_float32"
    "test_coverage_normal_cpu_float32"
    "test_coverage_normal_number_mean_cpu_float32"
    "test_coverage_pca_lowrank_cpu_float32"
    "test_coverage_round_decimals_0_cpu_float32"
    "test_coverage_round_decimals_3_cpu_float32"
    "test_coverage_round_decimals_neg_3_cpu_float32"
    "test_coverage_scatter_reduce_cpu_float32"
    "test_coverage_svd_lowrank_cpu_float32"

    # >       self.assertEqual(len(functorch_lagging_op_db), len(op_db))
    # E       AssertionError: Scalars are not equal!
    # E
    # E       Absolute difference: 19
    # E       Relative difference: 0.03525046382189239
    "test_functorch_lagging_op_db_has_opinfos_cpu"

    # RuntimeError: PyTorch not compiled with LLVM support!
    "test_bias_gelu"
    "test_binary_ops"
    "test_broadcast1"
    "test_broadcast2"
    "test_float_double"
    "test_float_int"
    "test_fx_trace"
    "test_int_long"
    "test_issue57611"
    "test_slice1"
    "test_slice2"
    "test_transposed1"
    "test_transposed2"
    "test_unary_ops"
  ];

  pythonImportsCheck = [ "functorch" ];

  meta = with lib; {
    description = "JAX-like composable function transforms for PyTorch";
    homepage = "https://pytorch.org/functorch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
    # See https://github.com/NixOS/nixpkgs/pull/174248#issuecomment-1139895064.
    platforms = platforms.x86_64;
  };
}
