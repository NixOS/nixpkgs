{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, importlib-metadata
, openai
, python-dotenv
, tiktoken
}:
let
  version = "0.1.590";
in
buildPythonPackage rec {
  pname = "litellm";
  format = "pyproject";
  inherit version;

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    rev = "7cb96e86b4753008cbf8d116aca514750e98d360";
    hash = "sha256-ITMcwGjelNfNGnfBmmdu0Xwph4u0mxiFSfHnysUxWCQ=";
  };

  postPatch = ''
    rm -rf dist
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    importlib-metadata
    openai
    python-dotenv
    tiktoken
  ];

  # the import check phase fails trying to do a network request to openai
  # pythonImportsCheck = [ "litellm" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Use any LLM as a drop in replacement for gpt-3.5-turbo. Use Azure, OpenAI, Cohere, Anthropic, Ollama, VLLM, Sagemaker, HuggingFace, Replicate (100+ LLMs)";
    homepage = "https://github.com/BerriAI/litellm";
    license = licenses.mit;
    changelog = "https://github.com/BerriAI/litellm/releases/tag/v${version}";
    maintainers = with maintainers; [ happysalada ];
  };
}
