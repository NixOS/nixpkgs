{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
, msrestazure
, requests
}:

buildPythonPackage rec {
  version = "1.2.0";
  format = "setuptools";
  pname = "azure-multiapi-storage";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CQuoWHeh0EMitTRsvifotrTwpWd/Q9LWWD7jZ2w9r8I=";
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
