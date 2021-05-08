{ buildPythonPackage
, fetchPypi
, isPy3k
, lib

# pythonPackages
, azure-core
, cryptography
, msrest
, futures ? null
}:

buildPythonPackage rec {
  pname = "azure-storage-file-share";
  version = "12.4.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "6c458d1e3db38fdd502d8f77107c81e6859654f02c0e7f2a98214289d9e0dde2";
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
