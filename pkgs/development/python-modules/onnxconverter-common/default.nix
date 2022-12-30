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
  version = "1.13.0"; # Upstream no longer seems to push tags
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxconverter-common";
    rev = "refs/tags/v${version}";
    hash = "sha256-VT9ly0d0Yhw1J6C521oUyaCx4WtFSdpyk8EdIKlre3c=";
  };

  propagatedBuildInputs = [
    numpy
    packaging # undeclared dependency
    protobuf
    onnx
  ];

  checkInputs = [
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
