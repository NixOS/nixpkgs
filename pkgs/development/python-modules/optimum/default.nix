{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  datasets,
  huggingface-hub,
  numpy,
  packaging,
  torch,
  transformers,

  # optional-dependencies
  optimum-onnx,
}:

buildPythonPackage rec {
  pname = "optimum";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "optimum";
    tag = "v${version}";
    hash = "sha256-lUTnO1MVcYd6TnHVqs6RGV7By6U44pdoqd67c/YKfk8=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "transformers" ];

  dependencies = [
    huggingface-hub
    numpy
    packaging
    torch
    transformers
  ];

  optional-dependencies = {
    onnx = [
      optimum-onnx
    ];
    onnxruntime = [
      optimum-onnx
    ]
    ++ optimum-onnx.optional-dependencies.onnxruntime;
    intel = [
      # optimum-intel
    ];
    openvino = [
      # optimum-intel
    ]; # ++ optimum-intel.optional-dependencies.openvino;
    nncf = [
      # optimum-intel
    ]; # ++ optimum-intel.optional-dependencies.nncf;
    neural-compressor = [
      # optimum-intel
    ]; # ++ optimum-intel.optional-dependencies.neural-compressor;
    graphcore = [
      # optimum-graphcore
    ];
    habana = [
      # optimum-habana
    ];
    neuron = [
      # optimum-neuron
    ]; # ++ optimum-neuron.optional-dependencies.neuron;
    neuronx = [
      # optimum-neuron
    ]; # ++ optimum-neuron.optional-dependencies.neuronx;
    furiosa = [
      # optimum-furiosa
    ];
  };

  # almost all tests try to connect to https://huggingface.co
  doCheck = false;

  pythonImportsCheck = [ "optimum" ];

  meta = {
    description = "Accelerate training and inference of Transformers and Diffusers with easy to use hardware optimization tools";
    mainProgram = "optimum-cli";
    homepage = "https://github.com/huggingface/optimum";
    changelog = "https://github.com/huggingface/optimum/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
