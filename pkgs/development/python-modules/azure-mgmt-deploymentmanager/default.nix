{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "azure-mgmt-deploymentmanager";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c6pyr36n9snx879vas5r6l25db6nlp2z96xn759mz4kg4i45qs6";
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
