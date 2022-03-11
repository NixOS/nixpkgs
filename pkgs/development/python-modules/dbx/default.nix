{ buildPythonPackage
, fetchPypi
, databricks-cli
, scipy
, pathpy
, tqdm
, mlflow
, azure-identity
, ruamel_yaml
, emoji
, cookiecutter
, retry
, azure-mgmt-datafactory
, azure-mgmt-subscription
, lib
}:

buildPythonPackage rec {
  pname = "dbx";
  version = "0.4.1";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    sha256 = "PzLxks8DPVXKF63S10+/9+gqxnXd1MTlDIimKPJq12M=";
  };

  propagatedBuildInputs = [
    databricks-cli
    scipy
    pathpy
    tqdm
    mlflow
    azure-identity
    ruamel_yaml
    emoji
    cookiecutter
    retry
    azure-mgmt-datafactory
    azure-mgmt-subscription
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/databrickslabs/dbx";
    description = "CLI tool for advanced Databricks jobs management";
    license = {
      fullName = "DataBricks eXtensions aka dbx License";
      url = "https://github.com/databrickslabs/dbx/blob/743b579a4ac44531f764c6e522dbe5a81a7dc0e4/LICENSE";
      free = false;
      redistributable = false;
    };
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
