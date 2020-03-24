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
  version = "1.3.0";
  disabled = isPy38;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "17fa904e0447fd2a2dc19909379edb769b05656dbaf4863b8c4fdfb2bb54350c";
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
