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
  version = "1.15.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxconverter-common";
    tag = "v${version}";
    hash = "sha256-e4rk1qTTSEFu+g/cP+RmMUqxkBQfodIpr2CVK24DPv4=";
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
    changelog = "https://github.com/microsoft/onnxconverter-common/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
  };
}
