{
  lib,
  stdenv,
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

buildPythonPackage (finalAttrs: {
  pname = "onnx-ir";
  version = "0.1.14_1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "ir-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mlUz5LGMtW4q78lBcbjo96V7k6NL+mt1lSvOU/6GEOY=";
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

    # Flaky:
    # onnx.onnx_cpp2py_export.checker.ValidationError: No Op registered for LabelEncoder with domain_version of 4
    # ==> Context: Bad node spec for node. Name:  OpType: LabelEncoder
    "SerdeTest"

    # Circular dependency with onnxscript
    "test_correct_module_name"
  ];

  disabledTestPaths = [
    # Circular dependency with onnxscript
    "src/onnx_ir/passes/common/common_subexpression_elimination_test.py"
  ];

  # Importing onnxruntime in the sandbox crashes on aarch64-linux:
  # Fatal Python error: Aborted
  # See https://github.com/NixOS/nixpkgs/pull/481039
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  meta = {
    description = "Efficient in-memory representation for ONNX, in Python";
    homepage = "https://github.com/onnx/ir-py";
    changelog = "https://github.com/onnx/ir-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
