{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "85c9c25612f160897ae212532ec7c19c94b0f4463f4830d0ee08cb2d296df407";
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
