{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.0.0";
  format = "setuptools";
  pname = "azure-mgmt-deploymentmanager";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9badb768617209149c33e68ca2e59c35b1d3d11427e2969872f2e236e14eee78";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

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
