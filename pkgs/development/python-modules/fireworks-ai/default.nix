{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  httpx,
  pydantic,
  typing-extensions,
  anyio,
  distro,
  sniffio,
  aiohttp,
  httpx-aiohttp,

  # optional dependencies
  datasets,
  numpy,
  requests,
  tiktoken,
  # tinker -- not packaged yet
  torch,
  transformers,
  wandb,

  # tests
  dirty-equals,
  pytest-asyncio,
  pytestCheckHook,
  respx,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "fireworks-ai";
  version = "1.2.0-alpha.71";
  pyproject = true;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fw-ai-external";
    repo = "python-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5JjcYa3dRh1JTRjOIDpC8wykYzdj1rrMcU49UvWF7w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.3" "hatchling>=1.26.3"
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    aiohttp
    anyio
    distro
    httpx
    httpx-aiohttp
    pydantic
    sniffio
    typing-extensions
  ];

  optional-dependencies = {
    training-sdk = [
      # tinker is not available in nixpkgs
      requests
    ];
    training = [
      datasets
      numpy
      tiktoken
      torch
      transformers
      wandb
    ]
    ++ finalAttrs.passthru.optional-dependencies.training-sdk;
  };

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytestCheckHook
    respx
    time-machine
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [
    "fireworks"
  ];

  meta = {
    description = "Client library for Fireworks.ai";
    homepage = "https://github.com/fw-ai-external/python-sdk";
    changelog = "https://github.com/fw-ai-external/python-sdk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
