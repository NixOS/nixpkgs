{
  lib,
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

  # tests
  onnxruntime,
  parameterized,
  pytestCheckHook,
  torch,
  torchvision,
  tqdm,
}:

buildPythonPackage rec {
  pname = "onnxscript";
  version = "0.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxscript";
    tag = "v${version}";
    hash = "sha256-8QnVfdI5sfPXF72fbbowbGxVRAnNQr55YEi/QEmXbCw=";
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

  disabledTests = [
    # fixture 'model_info' not found
    "test_model"

    # Exception: Caused by sample input at index 0: SampleInput(input=Tensor[size=(5, 5, 5), device="cpu", dtype=torch.bool], args=(2), kwargs={}, broadcasts_input=False, name='')
    "test_output_match_opinfo__split_cpu_bool"
    # Exception: Caused by sample input at index 0: SampleInput(input=Tensor[size=(5, 5, 5), device="cpu", dtype=torch.bool], args=((1,3,1)), kwargs={}, broadcasts_input=False, name='')
    "test_output_match_opinfo__split_list_args_cpu_bool"
    # Exception: Caused by sample input at index 0: SampleInput(input=Tensor[size=(5, 5, 5), device="cpu", dtype=torch.bool], args=((1,3,1)), kwargs={}, broadcasts_input=False, name='')
    "test_output_match_opinfo__split_with_sizes_cpu_bool"

  ]
  ++ lib.optionals config.cudaSupport [
    # Fatal Python error: Aborted
    # Current thread 0x00007ffff7603740 (most recent call first):
    # File "/nix/store/7smdv1zy2z48jxghc0daj61rd30c8dd0-python3.13-onnxruntime-1.22.2/lib/python3.13/site-packages/onnxruntime/capi/onnxruntime_inference_collection.py", line 561 in _create_inference_session
    # File "/nix/store/7smdv1zy2z48jxghc0daj61rd30c8dd0-python3.13-onnxruntime-1.22.2/lib/python3.13/site-packages/onnxruntime/capi/onnxruntime_inference_collection.py", line 472 in __init__
    # File "/build/source/onnxscript/rewriter/testing.py", line 124 in _ort_session_initializer
    # File "/build/source/onnxscript/rewriter/testing.py", line 86 in assert_numerically_equal
    # File "/build/source/onnxscript/rewriter/rules/common/_basic_rules_test.py", line 507 in test_reshape_dynamic_reshape_rule
    "test_reshape_dynamic_reshape_rule"
    "test_reshape_reshape_dynamic_rule"
  ];

  disabledTestPaths = [
    # google.protobuf.message.DecodeError: Error parsing message with type 'onnx.ModelProto'
    "tests/ir/graph_view_test.py"
    "tests/ir/serde_roundtrip_test.py"
    "tests/optimizer/test_models.py"
  ];

  meta = {
    description = "Naturally author ONNX functions and models using a subset of Python";
    homepage = "https://github.com/microsoft/onnxscript";
    changelog = "https://github.com/microsoft/onnxscript/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
