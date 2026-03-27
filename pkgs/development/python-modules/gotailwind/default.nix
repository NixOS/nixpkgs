{
  lib,
  aiohttp,
  aresponses,
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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-gotailwind";
    tag = "v${version}";
    hash = "sha256-kNyqSyJ1ha+BumYX4ruWaN0akEvUEsRxPs7Fj7LDHOw=";
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
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "gotailwind" ];

  meta = {
    description = "Modul to communicate with Tailwind garage door openers";
    homepage = "https://github.com/frenck/python-gotailwind";
    changelog = "https://github.com/frenck/python-gotailwind/releases/tag/v$version";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tailwind";
  };
}
