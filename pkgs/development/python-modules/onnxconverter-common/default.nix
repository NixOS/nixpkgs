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
  version = "1.13.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxconverter-common";
    rev = "refs/tags/v${version}";
    hash = "sha256-VT9ly0d0Yhw1J6C521oUyaCx4WtFSdpyk8EdIKlre3c=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
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
    homepage = "https://github.com/microsoft/onnxconverter-common";
    changelog = "https://github.com/microsoft/onnxconverter-common/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ fridh ];
    license = with lib.licenses; [ mit ];
  };
}
