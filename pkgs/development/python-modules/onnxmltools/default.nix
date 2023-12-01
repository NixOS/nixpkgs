{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, onnx
, skl2onnx
# native check inputs
, pytestCheckHook
, pandas
, xgboost
, onnxruntime
, scikit-learn
, pyspark
, lightgbm
}:

buildPythonPackage rec {
  pname = "onnxmltools";
  version = "1.11.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnxmltools";
    rev = "v${version}";
    hash = "sha256-uLFAGtCDLdMd0SMoonMXFE0kGHuDpwp6IrIbD0t8l4M=";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "ONNXMLTools enables conversion of models to ONNX";
    homepage = "https://github.com/onnx/onnxmltools";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
