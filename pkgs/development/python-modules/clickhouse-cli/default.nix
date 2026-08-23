{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  prompt-toolkit,
  pygments,
  requests,
  sqlparse,
}:

buildPythonPackage rec {
  pname = "clickhouse-cli";
  version = "0.3.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gkgLAedUtzGv/4P+D56M2Pb5YecyqyVYp06ST62sjdY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonRelaxDeps = [ "sqlparse" ];

  propagatedBuildInputs = [
    click
    prompt-toolkit
    pygments
    requests
    sqlparse
  ];

  pythonImportsCheck = [ "clickhouse_cli" ];

  meta = {
    description = "Third-party client for the Clickhouse DBMS server";
    mainProgram = "clickhouse-cli";
    homepage = "https://github.com/hatarist/clickhouse-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivan-babrou ];
  };
}
