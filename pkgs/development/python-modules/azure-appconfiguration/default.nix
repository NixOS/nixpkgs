{ lib, buildPythonPackage, fetchPypi, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "9372467c74930d20827135d468b7fcaa1ad42e4673a4591ceadbb6ad8e1b7e07";
  };

  propagatedBuildInputs = [
    azure-core
    msrest
  ];

  pythonImportsCheck = [ "azure.appconfiguration" ];

  meta = with lib; {
    description = "Microsoft App Configuration Data Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/appconfiguration/azure-appconfiguration";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
