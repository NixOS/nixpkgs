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
  version = "12.0.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "15f5vk3vd2amggqqznx186raak9wgr57j0l1p9qa62kcl10bs9lg";
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
