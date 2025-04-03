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
  email-validator,
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
  uvloop,
  uvicorn,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "litellm";
  version = "1.63.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "BerriAI";
    repo = "litellm";
    tag = "v${version}-stable";
    hash = "sha256-j2RfuVffmWoeAAVcT579S9pU06haKEYYa7FcpMzu9uA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    click
    email-validator
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
      uvloop
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

  passthru.tests = {
    inherit (nixosTests) litellm;
  };

  meta = {
    description = "Use any LLM as a drop in replacement for gpt-3.5-turbo. Use Azure, OpenAI, Cohere, Anthropic, Ollama, VLLM, Sagemaker, HuggingFace, Replicate (100+ LLMs)";
    mainProgram = "litellm";
    homepage = "https://github.com/BerriAI/litellm";
    changelog = "https://github.com/BerriAI/litellm/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
