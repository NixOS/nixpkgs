{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  aistore,
  boto3,
  einops,
  fsspec,
  h5py,
  huggingface-hub,
  hydra-core,
  loguru,
  numpy,
  pandas,
  psutil,
  pyvista,
  rtree,
  submitit,
  torch,
  trimesh,
  typer,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "emmiai-noether";
  version = "2026.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Emmi-AI";
    repo = "noether";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ySQxI0n4mPKio7tlRkRRdSq/ieIigznur2CZhJfbyLs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "numpy"
    "torch"
  ];
  dependencies = [
    aistore
    boto3
    einops
    fsspec
    h5py
    huggingface-hub
    hydra-core
    loguru
    numpy
    pandas
    psutil
    pyvista
    rtree
    submitit
    torch
    trimesh
    typer
  ];

  pythonImportsCheck = [ "noether" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Checks if code.tar.gz exists
    "test_train_pipeline_copies_code"

    # Fails to properly count the number of cores in the sandbox
    "test_total_cpu_count_fallback"
    "test_total_cpu_count_linux"
    "test_total_cpu_count_mac"
    "test_total_cpu_count_windows"

    # Numerical precision asertion errors since torch was updated to 2.12.0
    # AssertionError: Output is not as expected
    "test_ab_upt_determinism_regression_check"
    "test_double_kwargs"
    "test_forward_shape"
    "test_forward_transolver_attention"
    "test_forward_with_mask"
    "test_perceiver_attention_forward_shape"
    "test_perceiver_block_forward"
    "test_rope_perceiver"
    "test_rope_transformer"
    "test_single"
    "test_transformer_block_forward"
    "test_transformer_determinism_regression_check"
    "test_transolver_determinism_regression_check"
    "test_upt_determinism_regression_check"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky: assert 0.32007395901018754 == 0.3 ± 0.02
    "test_real_time_accuracy"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Deep-Learning framework for Engineering AI";
    homepage = "https://github.com/Emmi-AI/noether";
    changelog = "https://github.com/Emmi-AI/noether/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.enpl;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
