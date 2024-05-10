{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, orjson
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, respx
, rich
, syrupy
, tenacity
, typer
}:

buildPythonPackage rec {
  pname = "pytrydan";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = "pytrydan";
    rev = "refs/tags/v${version}";
    hash = "sha256-+hFwBFYtRseVwesZtSrL3J/ZnsMAjD2ZAhTlk41hfqU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=pytrydan --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "pytrydan"
  ];

  meta = with lib; {
    description = "Library to interface with V2C EVSE Trydan";
    mainProgram = "pytrydan";
    homepage = "https://github.com/dgomes/pytrydan";
    changelog = "https://github.com/dgomes/pytrydan/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
