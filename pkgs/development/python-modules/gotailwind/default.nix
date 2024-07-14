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
  pytestCheckHook,
  pythonOlder,
  syrupy,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "gotailwind";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-gotailwind";
    rev = "refs/tags/v${version}";
    hash = "sha256-FRFcFn5aRg+H9M6ZwEfLO1Dwcybvs0ODQv2ruCG+4v0=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}" \
      --replace-fail "--cov" ""
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

  passthru.optional-dependencies = {
    cli = [ typer ];
  };

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "gotailwind" ];

  meta = with lib; {
    description = "Modul to communicate with Tailwind garage door openers";
    homepage = "https://github.com/frenck/python-gotailwind";
    changelog = "https://github.com/frenck/python-gotailwind/releases/tag/v$version";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "tailwind";
  };
}
