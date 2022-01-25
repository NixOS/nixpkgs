{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "9.0.0";
  pname = "azure-mgmt-containerregistry";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f6c5894d32ba696527ecf0ff155bb43c325dff6a11a6de60cd22ea3f5fb180d";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common azure-mgmt-core msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.containerregistry" ];

  meta = with lib; {
    description = "Microsoft Azure Container Registry Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
