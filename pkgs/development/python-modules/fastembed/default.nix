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

buildPythonPackage {
  pname = "fastembed";
  version = "unstable-2023-09-07";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "fastembed";
    rev = "9c5d32f271dfe9ae4730694727ff5df480983942";
    hash = "sha256-d7Zb0IL0NOPEPsCHe/ZMNELnSCG4+y8JmGAXnCRUd50=";
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
