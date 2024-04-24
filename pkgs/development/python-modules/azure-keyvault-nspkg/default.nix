{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, azure-nspkg
}:

buildPythonPackage rec {
  pname = "azure-keyvault-nspkg";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0hdnd6124hx7s16z1pssmq5m5mqqqz8s38ixl9aayv4wmf5bhs5c";
  };

  propagatedBuildInputs = [
    azure-nspkg
  ];

  # Just a namespace package, no tests exist:
  #   https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/keyvault/tests.yml
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Key Vault Namespace Package [Internal]";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
