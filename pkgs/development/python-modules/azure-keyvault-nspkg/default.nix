{
  buildPythonPackage,
  fetchPypi,
  lib,

  # pythonPackages
  azure-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-nspkg";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-rGi4iqucbK9Uoj2iodHHGNdSC65a3/BN0KdDIoJptkE=";
  };

  propagatedBuildInputs = [ azure-nspkg ];

  # Just a namespace package, no tests exist:
  #   https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/keyvault/tests.yml
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Key Vault Namespace Package [Internal]";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
