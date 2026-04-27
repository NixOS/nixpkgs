{
  lib,
  stdenv,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ml-dtypes,
  numpy,
  onnx,
  onnx-ir,
  packaging,
  typing-extensions,
  # cuda-only:
  nvidia-ml-py,

  # tests
  onnxruntime,
  parameterized,
  pytestCheckHook,
  torch,
  torchvision,
  tqdm,

  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage (finalAttrs: {
  pname = "onnxscript";
  version = "0.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxscript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PktzMtG8GpeRy3XUz8MFbOSISVzAIubpeOS0ESbVvrI=";
  };

  env = {
    ONNX_SCRIPT_RELEASE = "1";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ml-dtypes
    numpy
    onnx
    onnx-ir
    packaging
    typing-extensions
  ]
  ++ lib.optionals cudaSupport [
    nvidia-ml-py
  ];

  pythonImportsCheck = [ "onnxscript" ];

  nativeCheckInputs = [
    onnxruntime
    parameterized
    pytestCheckHook
    torch
    torchvision
    tqdm
  ];

  enabledTestPaths = [
    "tests"
  ];

  disabledTests = [
    # fixture 'model_info' not found
    "test_model"

    # RuntimeError: ONNX Runtime failed to evaluate
    # onnxruntime.capi.onnxruntime_pybind11_state.NotImplemented: [ONNXRuntimeError] : 9 :
    # NOT_IMPLEMENTED : Could not find an implementation for SplitToSequence(11) node with name '_inlfunc_aten_split_n0'
    "test_output_match_opinfo__split_cpu_bool"
    "test_output_match_opinfo__split_list_args_cpu_bool"

    # RuntimeError: ONNX Runtime failed to evaluate
    # onnxruntime.capi.onnxruntime_pybind11_state.NotImplemented: [ONNXRuntimeError] : 9 :
    # NOT_IMPLEMENTED : Could not find an implementation for SplitToSequence(11) node with name '_inlfunc_aten_split_with_sizes_n0'
    "test_output_match_opinfo__split_with_sizes_cpu_bool"
  ];

  disabledTestPaths = [
    # google.protobuf.message.DecodeError: Error parsing message with type 'onnx.ModelProto'
    "tests/ir/graph_view_test.py"
    "tests/ir/serde_roundtrip_test.py"
    "tests/optimizer/test_models.py"
    # Wants GPU on ROCm
    "tests/function_libs/torch_lib/ops_test.py"
  ];

  # Importing onnxruntime in the sandbox crashes on aarch64-linux:
  # Fatal Python error: Aborted
  # See https://github.com/NixOS/nixpkgs/pull/481039
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  meta = {
    description = "Naturally author ONNX functions and models using a subset of Python";
    homepage = "https://github.com/microsoft/onnxscript";
    changelog = "https://github.com/microsoft/onnxscript/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
