{ lib
, buildPythonPackage
, fetchPypi
, click
, prompt-toolkit
, pygments
, requests
, sqlparse
}:

buildPythonPackage rec {
  pname = "clickhouse-cli";
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pa3vkIyNblS1LOwBReTqg8JAR2Ii32a2QIHWjau0uZE=";
  };

  propagatedBuildInputs = [
    click
    prompt-toolkit
    pygments
    requests
    sqlparse
  ];

  pythonImportsCheck = [ "clickhouse_cli" ];

  meta = with lib; {
    description = "A third-party client for the Clickhouse DBMS server";
    homepage = "https://github.com/hatarist/clickhouse-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan-babrou ];
  };
}
