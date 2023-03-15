{ lib, buildPythonPackage, fetchPypi, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-fzZyT6j3K90FClJawf3o0F2TSMSu5pVqZvP8yJwTdBc=";
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
