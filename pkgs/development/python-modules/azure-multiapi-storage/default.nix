{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
, msrestazure
, requests
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-multiapi-storage";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-x5v3e3/poSm+JMt0SWI1lcM6YAUcP+o2Sn8TluXOyIg=";
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
