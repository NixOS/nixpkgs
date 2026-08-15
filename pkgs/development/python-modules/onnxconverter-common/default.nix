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

let
  version = "1.16.0";
in

buildPythonPackage (finalAttrs: {
  pname = "onnxconverter-common";
  version =
    # prevent downgrade to 0.x tags, only 1.x are releases
    # https://pypi.org/project/onnxconverter-common/#history
    assert (lib.versionAtLeast version "1.0");
    version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxconverter-common";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M62mbIqFwnPdRlf6J8DrNRhLH0uHns51K/pWnWLxI5Q=";
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
    changelog = "https://github.com/microsoft/onnxconverter-common/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
