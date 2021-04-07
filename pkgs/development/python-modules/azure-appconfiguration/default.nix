{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b83cd2cb63d93225de84e27abbfc059212f8de27766f4c58dd3abb839dff0be4";
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
