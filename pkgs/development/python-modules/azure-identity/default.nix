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
  version = "1.4.0";
  disabled = isPy38;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "820e1f3e21f90d36063239c6cb7ca9a6bb644cb120a6b1ead3081cafdf6ceaf8";
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

  prePatch = ''
    substituteInPlace setup.py \
      --replace msal-extensions~=0.1.3 msal-extensions
  '';

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
