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
  pname = "azure-keyvault-secrets";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "066p4x2ixasz6qbxss2ilchl73w1kh2nc32lgh8qygl3d90059lp";
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
    description = "Microsoft Azure Key Vault Secrets Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
