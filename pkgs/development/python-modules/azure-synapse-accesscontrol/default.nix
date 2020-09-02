{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-accesscontrol";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rsdqrhrgy09kbw6c7krb4hlaxs1ldb6lilwrbxgp3zqybxxnh5b";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonImportsCheck = [ "azure.synapse.accesscontrol" ];

  meta = with lib; {
    description = "Azure python SDK";
    homepage = "https://github.com/Azure/azure-sdk-for-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
