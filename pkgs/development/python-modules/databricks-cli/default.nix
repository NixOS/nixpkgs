{ lib, buildPythonPackage, fetchFromGitHub
, click
, requests
, tabulate
, six
, configparser
, pytest
}:

buildPythonPackage rec {
  pname = "databricks-cli";
  version = "0.16.2";

  src = fetchFromGitHub {
     owner = "databricks";
     repo = "databricks-cli";
     rev = "0.16.2";
     sha256 = "0immd6csbdfkbls237lk9ajhr6s7m878n5jkw5m4gsd7049ns1f4";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = "pytest tests";
  # tests folder is missing in PyPI
  doCheck = false;

  propagatedBuildInputs = [
    click
    requests
    tabulate
    six
    configparser
  ];

  meta = with lib; {
    homepage = "https://github.com/databricks/databricks-cli";
    description = "A command line interface for Databricks";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
