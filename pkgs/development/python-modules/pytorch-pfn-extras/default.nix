{
  lib,
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
  stdenv,
}:

buildPythonPackage rec {
  pname = "pytorch-pfn-extras";
  version = "0.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pfnet";
    repo = "pytorch-pfn-extras";
    rev = "refs/tags/v${version}";
    hash = "sha256-0+ltkm7OH18hlpHYyZCmy1rRleF52IM2BjLoW44tJUY=";
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

  pytestFlagsArray = [
    # Requires CUDA access which is not possible in the nix environment.
    "-m 'not gpu and not mpi'"
    "-Wignore::DeprecationWarning"

    # FutureWarning: You are using `torch.load` with `weights_only=False` (the current default value), which uses the default pickle module implicitly...
    "-Wignore::FutureWarning"
  ];

  pythonImportsCheck = [ "pytorch_pfn_extras" ];

  disabledTests =
    [
      # AssertionError: assert 4 == 0
      # where 4 = <MagicMock id='140733587469184'>.call_count
      "test_lr_scheduler_wait_for_first_optimizer_step"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # torch.distributed is not available on darwin
      "test_create_distributed_evaluator"
      "test_distributed_evaluation"
      "test_distributed_evaluator_progress_bar"
    ];

  disabledTestPaths =
    [
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
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # RuntimeError: Dynamo is not supported on Python 3.12+
      "tests/pytorch_pfn_extras_tests/dynamo_tests/test_compile.py"
      "tests/pytorch_pfn_extras_tests/test_ops/test_register.py"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # torch.distributed is not available on darwin
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
    changelog = "https://github.com/pfnet/pytorch-pfn-extras/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
