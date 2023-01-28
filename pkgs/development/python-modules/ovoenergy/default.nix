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
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ZbLs8w0qeaV2qWP08FKnlZ3fefj15Bw2A2bGpL6/d0I=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
