{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "09fd9cf8c25c901d2daf7e436062065ada866f212f371f9d66f394d39ccaa23b";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonImportsCheck = [ "azure.synapse.artifacts" ];

  meta = with lib; {
    description = "CHANGE";
    homepage = "https://github.com/CHANGE/azure-synapse-artifacts/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
