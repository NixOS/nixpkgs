{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0mv053vl88nzpv701gnjdmbylc8qm0kkq87264rfhvrx3ydymf97";
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
