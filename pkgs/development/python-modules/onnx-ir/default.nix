{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ml-dtypes,
  numpy,
  onnx,
  typing-extensions,

  # tests
  onnxruntime,
  parameterized,
  pytestCheckHook,
  torch,
  tqdm,
}:

buildPythonPackage rec {
  pname = "onnx-ir";
  version = "0.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "ir-py";
    tag = "v${version}";
    hash = "sha256-5soRbGD+PlM0iNqDUtXESOv/2entgqAjstqKgiIJeXI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ml-dtypes
    numpy
    onnx
    typing-extensions
  ];

  pythonImportsCheck = [ "onnx_ir" ];

  nativeCheckInputs = [
    onnxruntime
    parameterized
    pytestCheckHook
    torch
    tqdm
  ];

  disabledTests = [
    # fixture 'model_info' not found
    "test_model"

    # onnx.onnx_cpp2py_export.checker.ValidationError: No Op registered for LabelEncoder with domain_version of 4
    # ==> Context: Bad node spec for node. Name:  OpType: LabelEncoder
    "test_serialization_deserialization_produces_same_model_0672_test_ai_onnx_ml_tree_ensemble_single_tree_model_onnx"
    "test_serialization_deserialization_produces_same_model_0689_test_ai_onnx_ml_binarizer_model_onnx"
    "test_serialization_deserialization_produces_same_model_0787_test_ai_onnx_ml_label_encoder_tensor_mapping_model_onnx"
    "test_serialization_deserialization_produces_same_model_0917_test_ai_onnx_ml_tree_ensemble_set_membership_model_onnx"
    "test_serialization_deserialization_produces_same_model_1062_test_ai_onnx_ml_label_encoder_tensor_value_only_mapping_model_onnx"
    "test_serialization_deserialization_produces_same_model_1588_test_ai_onnx_ml_array_feature_extractor_model_onnx"
    "test_serialization_deserialization_produces_same_model_1619_test_ai_onnx_ml_label_encoder_string_int_no_default_model_onnx"
    "test_serialization_deserialization_produces_same_model_1686_test_ai_onnx_ml_label_encoder_string_int_model_onnx"

    # Circular dependency with onnxscript
    "test_correct_module_name"
  ];

  disabledTestPaths = [
    # Circular dependency with onnxscript
    "src/onnx_ir/passes/common/common_subexpression_elimination_test.py"
  ];

  meta = {
    description = "Efficient in-memory representation for ONNX, in Python";
    homepage = "https://github.com/onnx/ir-py";
    changelog = "https://github.com/onnx/ir-py/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
