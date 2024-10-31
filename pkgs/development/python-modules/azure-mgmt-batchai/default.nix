{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
  msrestazure,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-batchai";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f1870b0f97d5001cdb66208e5a236c9717a0ed18b34dbfdb238a828f3ca2a683";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Batch AI Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
