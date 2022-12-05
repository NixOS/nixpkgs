{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, incremental
, pydantic
, pythonOlder
, pythonRelaxDepsHook
, typer
}:

buildPythonPackage rec {
  pname = "ovoenergy";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "${version}";
    hash = "sha256-ZbLs8w0qeaV2qWP08FKnlZ3fefj15Bw2A2bGpL6/d0I=";
  };

  pythonRelaxDeps = true;


  nativeBuildInputs = [
    incremental
    pythonRelaxDepsHook
  ];

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
