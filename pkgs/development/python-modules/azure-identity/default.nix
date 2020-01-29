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
  version = "1.1.0";
  disabled = isPy38;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1xn4nwi4vly8n3mmphv0wbdg9k55gsgmk3fdwma8rm3m3c7593hc";
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
