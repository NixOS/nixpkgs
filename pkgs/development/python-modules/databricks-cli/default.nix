{ stdenv, buildPythonPackage, fetchPypi
, click
, requests
, tabulate
, six
, configparser
, pytest
}:

buildPythonPackage rec {
  pname = "databricks-cli";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "68e5cdcf4ca26d3c628bca26e44563d58e64d3b2805b9adb94b4006976d9c7e1";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/databricks/databricks-cli";
    description = "A command line interface for Databricks";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
