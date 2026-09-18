{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools-scm,
  setuptools,

  accelerate,
  cohere,
  diskcache,
  fastapi,
  google-auth,
  httpx2,
  openai,
  pydantic,
  pyyaml,
  tiktoken,
  transformers,
  typer,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "llmx";
  version = "0.0.21a0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-OEo6wIaDTktzAsP0rOmhxjFSHygTR/EpcRI6AXsu+6M=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cohere
    diskcache
    google-auth
    httpx2
    openai
    pydantic
    pyyaml
    tiktoken
    typer
  ];

  optional-dependencies = {
    web = [
      fastapi
      uvicorn
    ];
    transformers = [
      accelerate
      transformers
    ]
    ++ transformers.optional-dependencies.torch;
  };

  # Tests of llmx try to access openai, google, etc.
  doCheck = false;

  pythonImportsCheck = [ "llmx" ];

  meta = {
    description = "Library for LLM Text Generation";
    homepage = "https://github.com/victordibia/llmx";
    mainProgram = "llmx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
