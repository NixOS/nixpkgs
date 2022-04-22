{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicelinker";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lAjgwEa2TJDEUU8pwfwkU8EyA1bhLkcAv++I6WHb7Xs=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  pythonImportsCheck = [ "azure.mgmt.servicelinker" ];

  # no tests with sdist
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Servicelinker Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
