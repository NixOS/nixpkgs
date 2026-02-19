{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  onnx,
  optimum,
  transformers,

  # optional-dependencies
  onnxruntime,
  # onnxruntime-gpu, unpackaged
  ruff,
}:

buildPythonPackage rec {
  pname = "optimum-onnx";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "optimum-onnx";
    tag = "v${version}";
    hash = "sha256-IFXtKkJwmrcdjfXE2YccbRylU723fTG70Z6c9fIL5mE=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "transformers"
  ];
  dependencies = [
    onnx
    optimum
    transformers
  ];

  optional-dependencies = {
    onnxruntime = [
      onnxruntime
    ];
    # onnxruntime-gpu = [ onnxruntime-gpu ];
    quality = [
      ruff
    ];
  };

  pythonImportsCheck = [ "optimum.onnxruntime" ];

  # Almost all tests need internet access
  doCheck = false;

  meta = {
    description = "Export your model to ONNX and run inference with ONNX Runtime";
    homepage = "https://github.com/huggingface/optimum-onnx";
    changelog = "https://github.com/huggingface/optimum-onnx/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
