{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-fancy-pypi-readme,
  hatchling,

  # dependencies (incl. optional)
  anyio,
  distro,
  httpx,
  pydantic,
  sniffio,
  typing-extensions,
  aiohttp,
  httpx-aiohttp,

  # tests
  pyright,
  mypy,
  respx,
  pytest,
  pytest-asyncio,
  ruff,
  time-machine,
  nox,
  dirty-equals,
  importlib-metadata,
  rich,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "perplexityai";
  version = "0.38.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "perplexityai";
    repo = "perplexity-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yp5A3aoKtAjWRPZ1Un2OYwezZohWirNm2JhAWLhd6uQ=";
  };

  # Can't use relaxPythonDeps as this is a version lock in the build system
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"hatchling==1.26.3"' '"hatchling"'
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
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
    pyright
    mypy
    respx
    pytest
    pytest-asyncio
    ruff
    time-machine
    nox
    dirty-equals
    importlib-metadata
    rich
    pytest-xdist
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
