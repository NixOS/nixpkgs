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
  version = "1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnxmltools";
    tag = "v${version}";
    hash = "sha256-uNd7N7/FgX8zaJp8ouvftwGqGqas8lZRXFmjpS+t2B4=";
  };

  postPatch = ''
    substituteInPlace onnxmltools/proto/__init__.py \
      --replace-fail \
        "from onnx.helper import split_complex_to_pairs" \
        "from onnx.helper import _split_complex_to_pairs as split_complex_to_pairs"
  '';

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
    changelog = "https://github.com/onnx/onnxmltools/blob/v${version}/CHANGELOGS.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
