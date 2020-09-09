{ buildPythonPackage
, fetchPypi
, isPy3k
, lib

# pythonPackages
, azure-core
, cryptography
, msrest
, futures
}:

buildPythonPackage rec {
  pname = "azure-storage-file-share";
  version = "12.2.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b649ed8afd67c10c9833f349a7c579d771a6425ad6b88027130a6b8cfa433ffb";
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
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
