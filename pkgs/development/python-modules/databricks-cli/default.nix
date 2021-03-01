{ lib, buildPythonPackage, fetchPypi
, click
, requests
, tabulate
, six
, configparser
, pytest
}:

buildPythonPackage rec {
  pname = "databricks-cli";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf94dc5187fa3500a31d52d7225fbc1a4699aa6e3c321223e7088eb5b5c94b62";
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
