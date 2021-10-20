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
  version = "12.6.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7eb0cde00fbbb6b780da8bdd81312ab79de706c4a2601e4eded1bc430da680a8";
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
