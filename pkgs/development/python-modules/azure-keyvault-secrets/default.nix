{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-keyvault-secrets";
  version = "4.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-wLcy253oVdnDl2YGfPQ+L2bNuyi4WfA8eH4zkkzKgtc=";
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
