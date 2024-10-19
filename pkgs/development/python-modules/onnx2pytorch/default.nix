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
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Talmaj";
    repo = "onnx2pytorch";
    rev = "refs/tags/v${version}";
    hash = "sha256-rEoFh96/yAmfGKJ/7pz4YT3pgee+CrpZcbt5Yl/IlbU=";
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

  disabledTests = [
    "test_loop_sum" # module 'numpy' has no attribute 'bool'
    "test_single_layer_lstm"
    # NotImplementedError
    "test_instancenorm"
    "test_instancenorm_lazy"
  ];

  meta = {
    description = "Transform ONNX model to PyTorch representation";
    homepage = "https://github.com/Talmaj/onnx2pytorch";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.asl20;
  };
}
