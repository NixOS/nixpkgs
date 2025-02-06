{
  lib,
  aiohttp,
  apscheduler,
  azure-identity,
  azure-keyvault-secrets,
  backoff,
  buildPythonPackage,
  click,
  cryptography,
  fastapi,
  fastapi-sso,
  fetchFromGitHub,
  google-cloud-kms,
  gunicorn,
  importlib-metadata,
  jinja2,
  jsonschema,
  openai,
  orjson,
  poetry-core,
  prisma,
  pydantic,
  pyjwt,
  pynacl,
  python-dotenv,
  python-multipart,
  pythonOlder,
  pyyaml,
  requests,
  resend,
  rq,
  tiktoken,
  tokenizers,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "litellm";
  version = "1.59.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    tag = "v${version}";
    hash = "sha256-2OkREmgs+r+vco1oEVgp5nq7cfwIAlMAh0FL2ceO88Y=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    click
    importlib-metadata
    jinja2
    jsonschema
    openai
    pydantic
    python-dotenv
    requests
    tiktoken
    tokenizers
  ];

  optional-dependencies = {
    proxy = [
      apscheduler
      backoff
      cryptography
      fastapi
      fastapi-sso
      gunicorn
      orjson
      pyjwt
      python-multipart
      pyyaml
      rq
      uvicorn
    ];
    extra_proxy = [
      azure-identity
      azure-keyvault-secrets
      google-cloud-kms
      prisma
      pynacl
      resend
    ];
  };

  pythonImportsCheck = [ "litellm" ];

  # access network
  doCheck = false;

  meta = with lib; {
    description = "Use any LLM as a drop in replacement for gpt-3.5-turbo. Use Azure, OpenAI, Cohere, Anthropic, Ollama, VLLM, Sagemaker, HuggingFace, Replicate (100+ LLMs)";
    mainProgram = "litellm";
    homepage = "https://github.com/BerriAI/litellm";
    changelog = "https://github.com/BerriAI/litellm/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
