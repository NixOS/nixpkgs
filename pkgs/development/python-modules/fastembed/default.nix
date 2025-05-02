{ lib
, buildPythonPackage
, fetchFromGitHub
, huggingface-hub
, pythonOlder
, pythonRelaxDepsHook
, poetry-core
, onnx
, onnxruntime
, requests
, tokenizers
, tqdm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastembed";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "fastembed";
    rev = "refs/tags/v${version}";
    hash = "sha256-ufgco5wPBG19GM99rZV7LKQqEzzCv24I8026SMz0CH4=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    huggingface-hub
    onnx
    onnxruntime
    requests
    tokenizers
    tqdm
  ];

  pythonImportsCheck = [
    "fastembed"
  ];

  pythonRelaxDeps = [
    "huggingface-hub"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # there is one test and it requires network
  doCheck = false;

  meta = with lib; {
    description = "Fast, Accurate, Lightweight Python library to make State of the Art Embedding";
    homepage = "https://github.com/qdrant/fastembed";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
