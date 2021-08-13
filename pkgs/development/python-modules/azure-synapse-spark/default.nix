{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-spark";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac7564a61ba314e0a9406c0f73c3cede04091a131a0c58971bcba0c158b7455d";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonImportsCheck = [ "azure.synapse.spark" ];

  meta = with lib; {
    description = "Azure python SDK";
    homepage = "https://github.com/Azure/azure-sdk-for-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
