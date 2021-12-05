{ buildPythonPackage, fetchPypi, lib

# pythonPackages
, azure-common, azure-core, azure-nspkg, cryptography, mock, msal
, msal-extensions, msrest, msrestazure }:

buildPythonPackage rec {
  pname = "azure-identity";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7f22cd0c7a9b92ed297dd67ae79d9bb9a866e404061c02cec709ad10c4c88e19";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-nspkg
    cryptography
    mock
    msal
    msal-extensions
    msrest
    msrestazure
  ];

  pythonImportsCheck = [ "azure.identity" ];

  # Requires checkout from mono-repo and a mock account:
  #   https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/identity/tests.yml
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Identity Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
