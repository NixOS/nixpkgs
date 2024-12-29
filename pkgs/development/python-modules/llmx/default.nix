{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  setuptools,
  pythonOlder,
  pydantic,
  openai,
  tiktoken,
  diskcache,
  cohere,
  google-auth,
  typer,
  pyyaml,
  transformers,
  fastapi,
  uvicorn,
  accelerate,
}:

buildPythonPackage rec {
  pname = "llmx";
  version = "0.0.21a0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OEo6wIaDTktzAsP0rOmhxjFSHygTR/EpcRI6AXsu+6M=";
  };

  disabled = pythonOlder "3.9";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pydantic
    openai
    tiktoken
    diskcache
    cohere
    google-auth
    typer
    pyyaml
  ];

  optional-dependencies = {
    web = [
      fastapi
      uvicorn
    ];
    transformers = [
      accelerate
      transformers
    ] ++ transformers.optional-dependencies.torch;
  };

  # Tests of llmx try to access openai, google, etc.
  doCheck = false;

  pythonImportsCheck = [ "llmx" ];

  meta = with lib; {
    description = "Library for LLM Text Generation";
    homepage = "https://github.com/victordibia/llmx";
    mainProgram = "llmx";
    license = licenses.mit;
    maintainers = with maintainers; [ moraxyc ];
  };
}
