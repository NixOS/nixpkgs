{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "azure-mgmt-deploymentmanager";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gvh17bhfcpvr6w0nd06v482m8lqxchlk256w68agi2qnqw6v2ir";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.deploymentmanager" ];

  meta = with lib; {
    description = "Microsoft Azure Deployment Manager Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
