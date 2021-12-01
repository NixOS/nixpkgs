{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-keyvault-secrets";
  version = "4.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "26279ba3a6c727deba1fb61f549496867baddffbf062bd579d6fd2bc04e95276";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # requires checkout from mono-repo
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Key Vault Secrets Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
