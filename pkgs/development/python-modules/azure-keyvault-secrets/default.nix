{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-keyvault-secrets";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-wLcy253oVdnDl2YGfPQ+L2bNuyi4WfA8eH4zkkzKgtc=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonNamespaces = [
    "azure.keyvault"
  ];

  # requires checkout from mono-repo
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Key Vault Secrets Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
