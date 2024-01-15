{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, onnxruntime
, requests
, tokenizers
, tqdm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastembed";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "fastembed";
    rev = "refs/tags/v${version}";
    hash = "sha256-FW85xeRcrPL3euXcQ3dS40SapimFgpWtRu6XiIzdzSM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    onnxruntime
    requests
    tokenizers
    tqdm
  ];

  pythonImportsCheck = [ "fastembed" ];

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
