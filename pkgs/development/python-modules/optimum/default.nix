{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  coloredlogs,
  datasets,
  diffusers,
  evaluate,
  h5py,
  huggingface-hub,
  numpy,
  onnx,
  onnxruntime,
  packaging,
  protobuf,
  setuptools,
  sympy,
  tensorflow,
  tf2onnx,
  timm,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "optimum";
  version = "1.20.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "optimum";
    rev = "refs/tags/v${version}";
    hash = "sha256-aQNDVNWTgY2LEtug229SEZRMvKHpsQfiTPWW4Lh3hs4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    coloredlogs
    datasets
    huggingface-hub
    numpy
    packaging
    sympy
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

  meta = with lib; {
    description = "Accelerate training and inference of 🤗 Transformers and 🤗 Diffusers with easy to use hardware optimization tools";
    mainProgram = "optimum-cli";
    homepage = "https://github.com/huggingface/optimum";
    changelog = "https://github.com/huggingface/optimum/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
