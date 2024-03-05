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

buildPythonPackage rec {
  pname = "onnxconverter-common";
  version = "1.14.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxconverter-common";
    rev = "refs/tags/v${version}";
    hash = "sha256-NbHyjLcr/Gq1zRiJW3ZBpEVQGVQGhp7SmfVd5hBIi2o=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    protobuf
    onnx
  ];

  pythonImportsCheck = [
    "onnxconverter_common"
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
    homepage = "https://github.com/microsoft/onnxconverter-common";
    changelog = "https://github.com/microsoft/onnxconverter-common/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ fridh ];
    license = with lib.licenses; [ mit ];
  };
}
