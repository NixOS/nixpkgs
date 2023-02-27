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
  version = "12.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-RlKL2q3O2gazyK7kCZLjgZZJ1K6vD0H2jpUV8epuhmQ=";
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
