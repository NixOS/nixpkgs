{ buildPythonPackage
, fetchFromGitHub
, lib
, numpy
, onnx
, skl2onnx
}: buildPythonPackage rec {
  pname = "onnxmltools";
  version = "1.11.1";
  src = fetchFromGitHub {
    owner = "onnx";
    repo = pname;
    rev = "${version}";
    hash = "sha256-6NXDRjkrk3O1RysmJ6Vo+kjCzBkfXl1uWKgrJiaU+Fw=";
  };

  propagatedBuildInputs = [ numpy onnx skl2onnx ];

  # Check stage dependencies broken
  doCheck = false;
  # checkInputs = [ pytestCheckHook pyspark lightgbm scipy pandas onxruntime ];
  meta = with lib; {
    description = "ONNXMLTools enables conversion of models to ONNX";
    homepage = "https://github.com/onnx/onnxmltools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ehllie ];
  };
}
