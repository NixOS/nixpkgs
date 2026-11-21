{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  databricks-sql-connector,
  duckdb,
  httpx2,
  numpy,
  pandas,
  plotly,
  pyarrow,
  pydantic,
  python-dateutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "genguardx";
  version = "2026.11.11";
  format = "wheel";

  # The source repository is private; PyPI publishes only a wheel.
  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-1TSaEEBlBa/3LN822uCVsIyh9G7LdEtcN8bhwyzZrZc=";
  };

  # The release pins duckdb>=2,<3; nixpkgs has 1.5.
  pythonRelaxDeps = [ "duckdb" ];

  dependencies = [
    databricks-sql-connector
    duckdb
    httpx2
    numpy
    pandas
    plotly
    pyarrow
    pydantic
    python-dateutil
    typing-extensions
  ];

  # The wheel ships no tests.
  doCheck = false;

  pythonImportsCheck = [ "genguardx" ];

  meta = {
    description = "Python SDK and command line for the GenGuardX platform";
    homepage = "https://genguardx.ai";
    changelog = "https://pypi.org/project/genguardx/${version}/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ js-codegamer ];
    mainProgram = "ggx";
  };
}
