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
  version = "12.5.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "ed82e9bf8d25d62e50996604fce701cec6a39ec0ceba6efbf8790f7f8b7746a8";
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
