{ lib
, buildPythonPackage
, datasette
, fetchFromGitHub
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "datasette-template-sql";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    hash = "sha256-VmdIEDk3iCBFrTPMm6ud00Z5CWqO0Wk707IQ4oVx5ak=";
  };

  propagatedBuildInputs = [
    datasette
  ];

  # Tests require a running datasette instance
  doCheck = false;

  pythonImportsCheck = [
    "datasette_template_sql"
  ];

  meta = with lib; {
    description = "Datasette plugin for executing SQL queries from templates";
    homepage = "https://datasette.io/plugins/datasette-template-sql";
    license = licenses.asl20;
    maintainers = with maintainers; [ MostAwesomeDude ];
  };
}
