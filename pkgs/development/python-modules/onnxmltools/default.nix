{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  onnx,
  skl2onnx,

  # tests
  pytestCheckHook,
  pandas,
  xgboost,
  onnxruntime,
  scikit-learn,
  pyspark,
  lightgbm,
}:

buildPythonPackage rec {
  pname = "onnxmltools";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnxmltools";
    tag = version;
    hash = "sha256-CcZlGLX8/ANHnhoOv5s/ybBN74gRH/8eLYJ6q/BJo/4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    onnx
    skl2onnx
  ];

  pythonImportsCheck = [ "onnxmltools" ];

  # there are still some dependencies that need to be packaged for the tests to run
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    xgboost
    onnxruntime
    scikit-learn
    pyspark
    lightgbm
    # coremltools
    # libsvm
    # h20
  ];

  meta = {
    description = "ONNXMLTools enables conversion of models to ONNX";
    homepage = "https://github.com/onnx/onnxmltools";
    changelog = "https://github.com/onnx/onnxmltools/blob/${src.tag}/CHANGELOGS.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
