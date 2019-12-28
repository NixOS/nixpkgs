{ buildPythonPackage
, fetchPypi
, lib

# Python dependencies
, azure-core
, azure-common
, azure-nspkg
, msrest
, msrestazure
, cryptography
}:

buildPythonPackage rec {
  pname = "azure-keyvault-keys";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1l1fwm8plzr5zbv02nlvs0i8ssmd88cxm5lb19i54b3scci77hiq";
  };

  propagatedBuildInputs = [
    azure-core
    azure-common
    azure-nspkg
    msrest
    msrestazure
    cryptography
  ];

  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Key Vault Keys Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
