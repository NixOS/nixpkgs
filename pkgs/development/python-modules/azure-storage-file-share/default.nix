{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# pythonPackages
, azure-core
, cryptography
, msrest
}:

buildPythonPackage rec {
  pname = "azure-storage-file-share";
  version = "12.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-46OEVjMYFUa8A6Qh+yicrqUuXmUaSzsWT4maBFG6Yqg=";
  };

  propagatedBuildInputs = [
    azure-core
    cryptography
    msrest
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
