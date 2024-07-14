{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-storage-nspkg";
  version = "3.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bzu+hlLV9UJ2fYQz5/lrjff1GHdAVax8ku18qF9lOBE=";
  };

  propagatedBuildInputs = [ azure-nspkg ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services owning the azure.storage namespace, user should not use this directly";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
