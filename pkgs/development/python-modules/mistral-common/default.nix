{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  numpy,
  pydantic,
  jsonschema,
  sentencepiece,
  typing-extensions,
  tiktoken,
  pillow,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mistral-common";
  version = "1.5.1";
  pyproject = true;

  build-system = [
    poetry-core
  ];

  disabled = pythonOlder "3.8";

  dependencies = [
    numpy
    pydantic
    jsonschema
    sentencepiece
    typing-extensions
    tiktoken
    pillow
    requests
  ];

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TaFqkR/P/xoKMCsB8G98CHN0I3d80S2uLYyDg0P88VE=";
  };

  meta = with lib; {
    description = "mistral-common is a set of tools to help you work with Mistral models.";
    homepage = "https://github.com/mistralai/mistral-common";
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
  };
}
