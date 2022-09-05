{ lib, buildPythonPackage, fetchPypi
, click
, oauthlib
, requests
, tabulate
, six
, configparser
, pytest
}:

buildPythonPackage rec {
  pname = "databricks-cli";
  version = "0.17.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LwDz5w6FmAnwWViF7Hb8c7pgrQzM1pVk999dlbbJAGY=";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = "pytest tests";
  # tests folder is missing in PyPI
  doCheck = false;

  propagatedBuildInputs = [
    click
    oauthlib
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
