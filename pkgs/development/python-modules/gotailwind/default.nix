{ lib
, aiohttp
, aresponses
, awesomeversion
, backoff
, buildPythonPackage
, fetchFromGitHub
, mashumaro
, orjson
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, syrupy
, typer
, yarl
, zeroconf
}:

buildPythonPackage rec {
  pname = "gotailwind";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-gotailwind";
    rev = "refs/tags/v${version}";
    hash = "sha256-JtMBud3iON4xLc9dQdXniv51EBqs7zkat8cYm3q0uEE=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    backoff
    mashumaro
    orjson
    yarl
    zeroconf
  ];

  passthru.optional-dependencies = {
    cli = [
      typer
    ];
  };

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "gotailwind"
  ];

  meta = with lib; {
    description = "Modul to communicate with Tailwind garage door openers";
    homepage = "https://github.com/frenck/python-gotailwind";
    changelog = "https://github.com/frenck/python-gotailwind/releases/tag/v$version";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
