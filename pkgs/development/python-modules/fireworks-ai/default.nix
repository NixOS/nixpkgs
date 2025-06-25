{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pdm-backend,

  # local dependencies
  black,
  mypy,

  # dependencies
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

let
  asyncstdlib-fw = buildPythonPackage rec {
    pname = "asyncstdlib_fw";
    version = "3.13.2";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Ua0JTCBMWTbDBA84wy/W1UmzkcmA8h8foJW2X7aAah8=";
    };

    build-system = [
      pdm-backend
    ];

    dependencies = [
      black
      mypy
    ];

    pythonImportsCheck = [
      "asyncstdlib"
    ];
  };

  betterproto-fw = buildPythonPackage rec {
    pname = "betterproto_fw";
    version = "2.0.3";
    pyproject = true;

    src = fetchPypi {
      inherit version pname;
      hash = "sha256-ut5GchUiTygHhC2hj+gSWKCoVnZrrV8KIKFHTFzba5M=";
    };

    build-system = [
      pdm-backend
    ];

    dependencies = [
      grpclib
      python-dateutil
      typing-extensions
    ];

    pythonImportsCheck = [
      "betterproto"
    ];

  };
in
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
    httpx-sse
    httpx-ws
    httpx-ws
    mmh3
    openai
    pillow
    pillow
    protobuf
    pydantic
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
