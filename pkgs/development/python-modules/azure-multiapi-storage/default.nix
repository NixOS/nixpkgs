{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
, msrestazure
, requests
}:

buildPythonPackage rec {
  version = "0.6.2";
  pname = "azure-multiapi-storage";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "74061f99730fa82c54d9b8ab3c7d6e219da3f30912740ecf0456b20cb3555ebc";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    msrestazure
    requests
  ];

  # fix namespace
  pythonNamespaces = [ "azure.multiapi" ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.multiapi.storage" ];

  meta = with lib; {
    description = "Microsoft Azure Storage Client Library for Python with multi API version support.";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
