{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "gotailwind";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-gotailwind";
    tag = "v${version}";
    hash = "sha256-sDQnweGVDyewvTPkRlmk9f7YMnUdPmvB9VrvegAC2B8=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    mashumaro
    orjson
    yarl
    zeroconf
  ];

  optional-dependencies = {
    cli = [ typer ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "gotailwind" ];

  meta = {
    description = "Modul to communicate with Tailwind garage door openers";
    homepage = "https://github.com/frenck/python-gotailwind";
    changelog = "https://github.com/frenck/python-gotailwind/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tailwind";
  };
}
