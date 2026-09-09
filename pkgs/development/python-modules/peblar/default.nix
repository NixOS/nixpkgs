{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  syrupy,
  tenacity,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "peblar";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-peblar";
    tag = "v${version}";
    hash = "sha256-LgeMj0/X+32P9FNBMrlhxql8Mjgi9Gmroquet8rkmis=";
  };

  postPatch = ''
    # Upstream doesn't set a version for GitHub releases
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    mashumaro
    orjson
    tenacity
    yarl
  ];

  optional-dependencies = {
    cli = [
      rich
      typer
      zeroconf
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "peblar" ];

  meta = {
    description = "Python client for Peblar EV chargers";
    homepage = "https://github.com/frenck/python-peblar";
    changelog = "https://github.com/frenck/python-peblar/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "peblar";
    maintainers = with lib.maintainers; [ fab ];
  };
}
