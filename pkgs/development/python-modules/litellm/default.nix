{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, importlib-metadata
, openai
, python-dotenv
, tiktoken
, tokenizers
, click
, jinja2
, certifi
, appdirs
, aiohttp
, httpx
}:
let
  version = "1.19.0";
in
buildPythonPackage rec {
  pname = "litellm";
  format = "pyproject";
  inherit version;

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    rev = "refs/tags/v${version}";
    hash = "sha256-cHGLOcOC9G6FlJfyrf+owURfGtn/gCAJuhSPt9lJS0o=";
  };

  postPatch = ''
    rm -rf dist
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    openai
    python-dotenv
    tiktoken
    importlib-metadata
    tokenizers
    click
    jinja2
    certifi
    appdirs
    aiohttp
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
