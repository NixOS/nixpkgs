{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pdm-backend,

  # dependencies
  asyncstdlib-fw,
  betterproto-fw,
  googleapis-common-protos,
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
  toml,
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
  version = "0.19.20";
  pyproject = true;

  # no source available
  src = fetchPypi {
    pname = "fireworks_ai";
    inherit version;
    hash = "sha256-zK8lO+vFnMEPPl79QGfqPdemZT7kQdCqAPiCrcXdqYQ=";
  };

  build-system = [
    pdm-backend
  ];

  pythonRelaxDeps = [
    "attrs"
    "protobuf"
  ];

  dependencies = [
    asyncstdlib-fw
    betterproto-fw
    googleapis-common-protos
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
    toml
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
