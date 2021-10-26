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
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8338597cec0f1d6d979a5ea2018cf6a134c8f991f6054656e82f995b6c6ab82";
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
