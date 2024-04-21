{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, lib
, numpy
, onnx
, packaging
, pytestCheckHook
, pythonAtLeast
, setuptools
, stdenv
, torch
, torchvision
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pytorch-pfn-extras";
  version = "0.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pfnet";
    repo = "pytorch-pfn-extras";
    rev = "refs/tags/v${version}";
    hash = "sha256-vSon/0GxQfaRtSPsQbYAvE3s/F0HEN59VpzE3w1PnVE=";
  };

  patches = [
    (fetchpatch {
      name = "relax-setuptools.patch";
      url = "https://github.com/pfnet/pytorch-pfn-extras/commit/96abe38c4baa6a144d604bdd4744c55627e55440.patch";
      hash = "sha256-85UDGcgJyQS5gINbgpNM58b3XJGvf+ArtGhwJ5EXdhk=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [ numpy packaging torch typing-extensions ];

  nativeCheckInputs = [ onnx pytestCheckHook torchvision ];

  pytestFlagsArray = [
    # Requires CUDA access which is not possible in the nix environment.
    "-m 'not gpu and not mpi'"
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "pytorch_pfn_extras" ];

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
  ] ++ lib.optionals (pythonAtLeast "3.12") [
    # RuntimeError: Dynamo is not supported on Python 3.12+
    "tests/pytorch_pfn_extras_tests/dynamo_tests/test_compile.py"
    "tests/pytorch_pfn_extras_tests/test_ops/test_register.py"
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # torch.distributed is not available on darwin
    "tests/pytorch_pfn_extras_tests/training_tests/extensions_tests/test_sharded_snapshot.py"
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: internal error
    # convolution (e.g. F.conv3d) causes runtime error
    "tests/pytorch_pfn_extras_tests/nn_tests/modules_tests/test_lazy_conv.py"
  ];

  meta = with lib; {
    description = "Supplementary components to accelerate research and development in PyTorch";
    homepage = "https://github.com/pfnet/pytorch-pfn-extras";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
