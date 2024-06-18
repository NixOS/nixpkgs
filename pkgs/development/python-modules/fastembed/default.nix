{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pythonRelaxDepsHook,

  # build-system
  poetry-core,

  # dependencies
  huggingface-hub,
  loguru,
  mmh3,
  numpy,
  onnx,
  onnxruntime,
  pillow,
  pystemmer,
  requests,
  snowballstemmer,
  tokenizers,
  tqdm,
}:

buildPythonPackage rec {
  pname = "fastembed";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "fastembed";
    rev = "refs/tags/v${version}";
    hash = "sha256-Tfj0YdUW/Nnvn4+RoOWj9l0gDkWbpVgiADA09ht4xxM=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    huggingface-hub
    loguru
    mmh3
    numpy
    onnx
    onnxruntime
    pillow
    pystemmer
    requests
    snowballstemmer
    tokenizers
    tqdm
  ];

  pythonImportsCheck = [ "fastembed" ];

  pythonRelaxDeps = [ "onnxruntime" ];

  # there is one test and it requires network
  doCheck = false;

  meta = {
    description = "Fast, Accurate, Lightweight Python library to make State of the Art Embedding";
    homepage = "https://github.com/qdrant/fastembed";
    changelog = "https://github.com/qdrant/fastembed/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
    badPlatforms = [ "aarch64-linux" ];
  };
}
