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
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w0my86r9fl0xqlczaqyp7v9rg7mpc42kp9swhids4qk4r5ncr2i";
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
