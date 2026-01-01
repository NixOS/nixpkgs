{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  huggingface-hub,
  loguru,
  mmh3,
  numpy,
  onnxruntime,
  pillow,
  py-rust-stemmers,
  pystemmer,
  requests,
  snowballstemmer,
  tokenizers,
  tqdm,
}:

buildPythonPackage rec {
  pname = "fastembed";
<<<<<<< HEAD
  version = "0.7.4";
=======
  version = "0.7.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "fastembed";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vEJcTTJr63xjWKWGJWTo6RnwFTmN6RQqGKh95xIT8RQ=";
=======
    hash = "sha256-sH/uiab+4fdowaEA+yNvA4PN7Xfuuu3eTF47FitEDvA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    huggingface-hub
    loguru
    mmh3
    numpy
    onnxruntime
    pillow
    py-rust-stemmers
    pystemmer
    requests
    snowballstemmer
    tokenizers
    tqdm
  ];

  pythonImportsCheck = [ "fastembed" ];

  pythonRelaxDeps = [
    "mmh3"
    "onnxruntime"
    "pillow"
  ];

  # there is one test and it requires network
  doCheck = false;

  meta = {
    description = "Fast, Accurate, Lightweight Python library to make State of the Art Embedding";
    homepage = "https://github.com/qdrant/fastembed";
    changelog = "https://github.com/qdrant/fastembed/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
    badPlatforms = [ "aarch64-linux" ];
  };
}
