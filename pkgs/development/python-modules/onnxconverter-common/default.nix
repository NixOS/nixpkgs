{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  packaging,
  protobuf,
  onnx,
  unittestCheckHook,
  onnxruntime,
}:

buildPythonPackage rec {
  pname = "onnxconverter-common";
  version = "1.14.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxconverter-common";
    rev = "refs/tags/v${version}";
    hash = "sha256-NbHyjLcr/Gq1zRiJW3ZBpEVQGVQGhp7SmfVd5hBIi2o=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = [
    numpy
    packaging
    protobuf
    onnx
  ];

  pythonImportsCheck = [ "onnxconverter_common" ];

  nativeCheckInputs = [
    onnxruntime
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  # Failing tests
  # https://github.com/microsoft/onnxconverter-common/issues/242
  doCheck = false;

  meta = {
    description = "ONNX Converter and Optimization Tools";
    homepage = "https://github.com/microsoft/onnxconverter-common";
    changelog = "https://github.com/microsoft/onnxconverter-common/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
  };
}
