{
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  griffe,
  hatchling,
  lib,
  mcp,
  numpy,
  openai,
  pydantic,
  requests,
  types-requests,
  typing-extensions,
  websockets,
}:

buildPythonPackage rec {
  pname = "openai-agents";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-agents-python";
    rev = "v${version}";
    hash = "sha256-2Kn+pG/pxl7ffBr54YFViNMnAkIy49Jy0njdb4PLhRI=";
  };

  patches = [ ./fix-import.patch ];

  build-system = [ hatchling ];

  dependencies = [
    griffe
    mcp
    openai
    pydantic
    requests
    types-requests
    typing-extensions
  ];

  optional-dependencies = {
    voice = [
      numpy
      websockets
    ];
    viz = [ graphviz ];
  };

  doCheck = false;
  pythonImportsCheck = [ "agents" ];

  meta = with lib; {
    description = "OpenAI Agents SDK - A lightweight, powerful framework for multi-agent workflows";
    homepage = "https://github.com/openai/openai-agents-python";
    license = licenses.mit;
    maintainers = [ wvhulle ];
  };
}
