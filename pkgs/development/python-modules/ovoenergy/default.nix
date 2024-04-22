{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, incremental
, pydantic
, pythonOlder
, typer
}:

buildPythonPackage rec {
  pname = "ovoenergy";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ZcTSf7UejEUqQo0qEXP3fWjZYRx0a3ZBNVkwS2dL3Yk=";
  };

  nativeBuildInputs = [
    incremental
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "typer==0.6.1" "typer"
  '';

  propagatedBuildInputs = [
    aiohttp
    click
    pydantic
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ovoenergy"
  ];

  meta = with lib; {
    description = "Python client for getting data from OVO's API";
    homepage = "https://github.com/timmo001/ovoenergy";
    changelog = "https://github.com/timmo001/ovoenergy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
