{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  torch,
  onnx,
  onnxruntime,
  torchvision,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "onnx2pytorch";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Talmaj";
    repo = "onnx2pytorch";
    tag = "v${version}";
    hash = "sha256-dK22RnJ46bNmHiX4m/2QFD6kEg6dh2gPo4YS5rcd6CI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    torch
    onnx
    onnxruntime
    torchvision
  ];

  pythonImportsCheck = [ "onnx2pytorch" ];

  pythonRelaxDeps = [ "torchvision" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Transform ONNX model to PyTorch representation";
    homepage = "https://github.com/Talmaj/onnx2pytorch";
    changelog = "https://github.com/Talmaj/onnx2pytorch/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.asl20;
  };
}
