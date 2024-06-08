{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
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
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gkgLAedUtzGv/4P+D56M2Pb5YecyqyVYp06ST62sjdY=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
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

  meta = with lib; {
    description = "A third-party client for the Clickhouse DBMS server";
    mainProgram = "clickhouse-cli";
    homepage = "https://github.com/hatarist/clickhouse-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan-babrou ];
  };
}
