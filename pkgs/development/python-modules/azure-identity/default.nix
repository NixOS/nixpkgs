{ buildPythonPackage
, fetchPypi
, isPy38
, lib

# pythonPackages
, azure-common
, azure-core
, azure-nspkg
, cryptography
, mock
, msal
, msal-extensions
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-identity";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "872adfa760b2efdd62595659b283deba92d47b7a67557eb9ff48f0b5d04ee396";
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
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
