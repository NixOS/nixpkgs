{ buildPythonPackage
, fetchFromGitHub
, lib
, datasette
, pytestCheckHook
, pytest-asyncio
, sqlite-utils
}:

buildPythonPackage rec {
  pname = "datasette-template-sql";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "1ag5f62y445jscxnklcfd84pjinkknmrpk1kmm2j121p7484hrsn";
  };

  propagatedBuildInputs = [ datasette ];

  checkInputs = [ pytestCheckHook pytest-asyncio sqlite-utils ];

  pythonImportsCheck = [ "datasette_template_sql" ];

  meta = with lib; {
    description = "Datasette plugin for executing SQL queries from templates";
    homepage = "https://datasette.io/plugins/datasette-template-sql";
    license = licenses.asl20;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}
