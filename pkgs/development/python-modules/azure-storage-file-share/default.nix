{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-core
, cryptography
, isodate
, msrest
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-storage-file-share";
  version = "12.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-Vnm72cdg/9P+J3Scnj5jcG6kLCdIVMGnxnU9an2oxGQ=";
  };

  propagatedBuildInputs = [
    azure-core
    cryptography
    isodate
    msrest
    typing-extensions
  ];

  # requires checkout from monorepo
  doCheck = false;

  pythonImportsCheck = [
    "azure.core"
    "azure.storage"
  ];

  meta = with lib; {
    description = "Microsoft Azure File Share Storage Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
