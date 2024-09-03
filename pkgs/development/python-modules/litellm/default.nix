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
  version = "1.44.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    rev = "refs/tags/v${version}";
    hash = "sha256-qEO5QWaW3Nd/zKNjZ31e5y5hNc55qZGDYCD66z+ftUk=";
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

  passthru.optional-dependencies = {
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
