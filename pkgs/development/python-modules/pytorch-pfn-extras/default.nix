{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  packaging,
  torch,
  typing-extensions,

  # tests
  onnx,
  pytestCheckHook,
  torchvision,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "pytorch-pfn-extras";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pfnet";
    repo = "pytorch-pfn-extras";
    tag = "v${version}";
    hash = "sha256-OrUYO0V5fWqkIjHiYkhvjeFy0YX8CxeRqzrw3NfGK2A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    packaging
    torch
    typing-extensions
  ];

  nativeCheckInputs = [
    onnx
    pytestCheckHook
    torchvision
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "pytorch_pfn_extras" ];

  disabledTestMarks = [
    # Requires CUDA access which is not possible in the nix environment.
    "gpu"
    "mpi"
  ];

  disabledTests = [
    # AssertionError: assert 4 == 0
    # where 4 = <MagicMock id='140733587469184'>.call_count
    "test_lr_scheduler_wait_for_first_optimizer_step"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # RuntimeError: Dynamo is not supported on Python 3.13+
    "test_register"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # torch.distributed was not available on darwin at one point; revisit
    "test_create_distributed_evaluator"
    "test_distributed_evaluation"
    "test_distributed_evaluator_progress_bar"
  ];

  disabledTestPaths = [
    # Requires optuna which is currently (2022-02-16) marked as broken.
    "tests/pytorch_pfn_extras_tests/test_config_types.py"

    # requires onnxruntime which was removed because of poor maintainability
    # See https://github.com/NixOS/nixpkgs/pull/105951 https://github.com/NixOS/nixpkgs/pull/155058
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_annotate.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_as_output.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_export.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_export_testcase.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_lax.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_load_model.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_torchvision.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/utils.py"

    # RuntimeError: No Op registered for Gradient with domain_version of 9
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_grad.py"

    # torch._dynamo.exc.BackendCompilerFailed: backend='compiler_fn' raised:
    # AttributeError: module 'torch.fx.experimental.proxy_tensor' has no attribute 'maybe_disable_fake_tensor_mode'
    "tests/pytorch_pfn_extras_tests/dynamo_tests/test_compile.py"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # torch.distributed was not available on darwin at one point; revisit
    "tests/pytorch_pfn_extras_tests/distributed_tests/test_distributed_validation_sampler.py"
    "tests/pytorch_pfn_extras_tests/nn_tests/parallel_tests/test_distributed.py"
    "tests/pytorch_pfn_extras_tests/profiler_tests/test_record.py"
    "tests/pytorch_pfn_extras_tests/profiler_tests/test_time_summary.py"
    "tests/pytorch_pfn_extras_tests/training_tests/extensions_tests/test_accumulate.py"
    "tests/pytorch_pfn_extras_tests/training_tests/extensions_tests/test_sharded_snapshot.py"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: internal error
    # convolution (e.g. F.conv3d) causes runtime error
    "tests/pytorch_pfn_extras_tests/nn_tests/modules_tests/test_lazy_conv.py"
  ];

  meta = {
    description = "Supplementary components to accelerate research and development in PyTorch";
    homepage = "https://github.com/pfnet/pytorch-pfn-extras";
    changelog = "https://github.com/pfnet/pytorch-pfn-extras/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
    badPlatforms = [
      # test_profile_report is broken on darwin
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
