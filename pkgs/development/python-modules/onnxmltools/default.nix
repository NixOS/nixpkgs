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

buildPythonPackage (finalAttrs: {
  pname = "onnxmltools";
  version = "1.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnxmltools";
    tag = finalAttrs.version;
    hash = "sha256-2cAxk/Qvu39N/IaIofuTFMciKyxVv3kwsnH4xpGrkIg=";
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
    changelog = "https://github.com/onnx/onnxmltools/blob/${finalAttrs.src.tag}/CHANGELOGS.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
