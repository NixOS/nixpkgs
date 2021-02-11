{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-accesscontrol";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "835e324a2072a8f824246447f049c84493bd43a1f6bac4b914e78c090894bb04";
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
