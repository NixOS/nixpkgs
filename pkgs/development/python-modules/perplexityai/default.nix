{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies (incl. optional)
  aiohttp,
  anyio,
  distro,
  httpx-aiohttp,
  httpx,
  pydantic,
  sniffio,
  typing-extensions,

  # tests
  dirty-equals,
  pytest-asyncio,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "perplexityai";
  version = "0.50.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "perplexity-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AkRgxHEnDAuItDU9bSpQ+ZPAR5vnfVkT/X1RoToTnwY=";
  };

  # The license classifier conflicts with the SPDX license expression
  postPatch = ''
    sed -i '/License :: OSI Approved/d' pyproject.toml
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    anyio
    distro
    httpx
    pydantic
    sniffio
    typing-extensions
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
  };

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytestCheckHook
    respx
  ]
  ++ finalAttrs.passthru.optional-dependencies.aiohttp;

  pythonImportsCheck = [
    "perplexity"
  ];

  meta = {
    description = "API for Perplexity AI";
    homepage = "https://github.com/perplexityai/perplexity-py";
    changelog = "https://github.com/perplexityai/perplexity-py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
