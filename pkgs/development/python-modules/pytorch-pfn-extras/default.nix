{ buildPythonPackage
, fetchFromGitHub
, lib
, numpy
, onnx
, packaging
, pytestCheckHook
, torch
, torchvision
, typing-extensions
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pytorch-pfn-extras";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "pfnet";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-juoLw/qfq4YF7opyR7cTYCVzUa9pXVvQnvGntcQhBr4=";
  };

  propagatedBuildInputs = [ numpy packaging torch typing-extensions ];

  nativeCheckInputs = [ onnx pytestCheckHook torchvision ];

  # ignore all pytest warnings
  preCheck = ''
    rm pytest.ini
  '';

  pythonImportsCheck = [ "pytorch_pfn_extras" ];

  disabledTestPaths = [
    # Requires optuna which is currently (2022-02-16) marked as broken.
    "tests/pytorch_pfn_extras_tests/test_config_types.py"

    # requires onnxruntime which was removed because of poor maintainability
    # See https://github.com/NixOS/nixpkgs/pull/105951 https://github.com/NixOS/nixpkgs/pull/155058
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_export.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_torchvision.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/utils.py"
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_lax.py"

    # RuntimeError: No Op registered for Gradient with domain_version of 9
    "tests/pytorch_pfn_extras_tests/onnx_tests/test_grad.py"

    # Requires CUDA access which is not possible in the nix environment.
    "tests/pytorch_pfn_extras_tests/cuda_tests/test_allocator.py"
    "tests/pytorch_pfn_extras_tests/nn_tests/modules_tests/test_lazy_batchnorm.py"
    "tests/pytorch_pfn_extras_tests/nn_tests/modules_tests/test_lazy_conv.py"
    "tests/pytorch_pfn_extras_tests/nn_tests/modules_tests/test_lazy_linear.py"
    "tests/pytorch_pfn_extras_tests/nn_tests/modules_tests/test_lazy.py"
    "tests/pytorch_pfn_extras_tests/profiler_tests/test_record.py"
    "tests/pytorch_pfn_extras_tests/runtime_tests/test_to.py"
    "tests/pytorch_pfn_extras_tests/handler_tests/test_handler.py"
    "tests/pytorch_pfn_extras_tests/test_reporter.py"
    "tests/pytorch_pfn_extras_tests/training_tests/test_trainer.py"
    "tests/pytorch_pfn_extras_tests/utils_tests/test_checkpoint.py"
    "tests/pytorch_pfn_extras_tests/utils_tests/test_comparer.py"
    "tests/pytorch_pfn_extras_tests/utils_tests/test_new_comparer.py"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # Remove this when https://github.com/NixOS/nixpkgs/pull/259068 is merged
    "tests/pytorch_pfn_extras_tests/dynamo_tests/test_compile.py"
  ];

  meta = with lib; {
    description = "Supplementary components to accelerate research and development in PyTorch";
    homepage = "https://github.com/pfnet/pytorch-pfn-extras";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
