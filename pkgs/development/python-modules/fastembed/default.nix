{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  huggingface-hub,
  loguru,
  pythonOlder,
  pythonRelaxDepsHook,
  poetry-core,
  onnx,
  onnxruntime,
  requests,
  tokenizers,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastembed";
  version = "0.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "fastembed";
    rev = "refs/tags/v${version}";
    hash = "sha256-ArLilvixzpHIGGAom4smX0jZ6lJSZe6tSGreeD+Pzmk=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    huggingface-hub
    loguru
    onnx
    onnxruntime
    requests
    tokenizers
    tqdm
  ];

  pythonImportsCheck = [ "fastembed" ];

  pythonRelaxDeps = [
    "huggingface-hub"
    "onnxruntime"
    "tokenizers"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # there is one test and it requires network
  doCheck = false;

  meta = with lib; {
    description = "Fast, Accurate, Lightweight Python library to make State of the Art Embedding";
    homepage = "https://github.com/qdrant/fastembed";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
