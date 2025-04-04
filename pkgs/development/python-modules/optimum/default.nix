{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  diffusers,
  evaluate,
  h5py,
  onnx,
  onnxruntime,
  protobuf,
  tensorflow,
  tf2onnx,
  timm,
}:

buildPythonPackage rec {
  pname = "optimum";
  version = "1.24.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "optimum";
    tag = "v${version}";
    hash = "sha256-0D/kHPUI+gM7IblA4ULs0JuGTNQVezIYg0SPD3ESukw=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "transformers" ];

  dependencies = [
    huggingface-hub
    numpy
    packaging
    torch
    transformers
  ] ++ transformers.optional-dependencies.sentencepiece;

  optional-dependencies = {
    onnxruntime = [
      onnx
      onnxruntime
      datasets
      evaluate
      protobuf
    ];
    exporters = [
      onnx
      onnxruntime
      timm
    ];
    exporters-tf = [
      tensorflow
      tf2onnx
      onnx
      onnxruntime
      timm
      h5py
      numpy
    ];
    diffusers = [ diffusers ];
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
      transformers
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
    description = "Accelerate training and inference of 🤗 Transformers and 🤗 Diffusers with easy to use hardware optimization tools";
    mainProgram = "optimum-cli";
    homepage = "https://github.com/huggingface/optimum";
    changelog = "https://github.com/huggingface/optimum/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
