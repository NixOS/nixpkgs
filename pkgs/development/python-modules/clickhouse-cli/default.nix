{ lib
, buildPythonPackage
, fetchPypi
, click
, prompt_toolkit
, pygments
, requests
, sqlparse
}:

buildPythonPackage rec {
  pname = "clickhouse-cli";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fDvUdL6LzgCv6LDmB0R0M7v6BbnbL68p9pHMebP58h8=";
  };

  propagatedBuildInputs = [
    click
    prompt_toolkit
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
