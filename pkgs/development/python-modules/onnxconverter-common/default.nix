{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, packaging
, protobuf
, onnx
, unittestCheckHook
, onnxruntime
}:

buildPythonPackage {
  pname = "onnxconverter-common";
  version = "1.12.2"; # Upstream no longer seems to push tags

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxconverter-common";
    rev = "814cdf494d987900d30b16971c0e8334aaca9ae6";
    hash = "sha256-XA/kl8aT1wLthl1bMihtv/1ELOW1sGO/It5XfJtD+sY=";
  };

  propagatedBuildInputs = [
    numpy
    packaging # undeclared dependency
    protobuf
    onnx
  ];

  nativeCheckInputs = [
    onnxruntime
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "tests" ];

  # Failing tests
  # https://github.com/microsoft/onnxconverter-common/issues/242
  doCheck = false;

  meta = {
    description = "ONNX Converter and Optimization Tools";
    maintainers = with lib.maintainers; [ fridh ];
    license = with lib.licenses; [ mit ];
  };
}
