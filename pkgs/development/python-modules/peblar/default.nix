{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "peblar";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-peblar";
    tag = "v${version}";
    hash = "sha256-cHb/VTaa7tkePqV7eLpDSxrnY8hAnjshwtwyWmJnt/4=";
  };

  postPatch = ''
    # Upstream doesn't set a version for GitHub releases
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    mashumaro
    orjson
    yarl
  ];

  optional-dependencies = {
    cli = [
      typer
      zeroconf
    ];
  };

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "peblar" ];

  meta = {
    description = "Python client for Peblar EV chargers";
    homepage = "https://github.com/frenck/python-peblar";
    changelog = "https://github.com/frenck/python-peblar/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
