{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pdm-backend,

  # dependencies
  asyncstdlib-fw,
  betterproto-fw,
  grpcio,
  grpclib,
  httpx-sse,
  httpx-ws,
  httpx,
  mmh3,
  openai,
  pillow,
  protobuf,
  pydantic,
  python-dateutil,
  rich,
  typing-extensions,

  # optional dependencies
  fastapi,
  gitignore-parser,
  openapi-spec-validator,
  prance,
  safetensors,
  tabulate,
  torch,
  tqdm,
}:

buildPythonPackage rec {
  pname = "fireworks-ai";
  version = "0.17.16";
  pyproject = true;

  # no source available
  src = fetchPypi {
    pname = "fireworks_ai";
    inherit version;
    hash = "sha256-WblcAaYjnzwPS4n5rixNHbHLNGTE3bTPXvQ9lYZ1f9A=";
  };

  build-system = [
    pdm-backend
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    asyncstdlib-fw
    betterproto-fw
    grpcio
    grpclib
    httpx
    httpx
    httpx-sse
    httpx-ws
    mmh3
    openai
    pillow
    protobuf
    pydantic
    python-dateutil
    rich
    typing-extensions
  ];

  optional-dependencies = {
    flumina = [
      fastapi
      gitignore-parser
      openapi-spec-validator
      prance
      safetensors
      tabulate
      torch
      tqdm
    ];
  };

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    "fireworks"
  ];

  meta = {
    description = "Client library for the Fireworks.ai platform";
    homepage = "https://pypi.org/project/fireworks-ai/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
