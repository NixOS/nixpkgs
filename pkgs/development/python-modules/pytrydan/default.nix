{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  respx,
  rich,
  syrupy,
  tenacity,
  typer,
}:

buildPythonPackage rec {
  pname = "pytrydan";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = "pytrydan";
    rev = "refs/tags/v${version}";
    hash = "sha256-OHC+Ul64BYCsgoFDxI1hPjBGkd/pQ0j0c9Pt5lWg1E0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=pytrydan --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    orjson
    rich
    tenacity
    typer
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
    syrupy
  ];

  pythonImportsCheck = [ "pytrydan" ];

  meta = with lib; {
    description = "Library to interface with V2C EVSE Trydan";
    homepage = "https://github.com/dgomes/pytrydan";
    changelog = "https://github.com/dgomes/pytrydan/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pytrydan";
  };
}
