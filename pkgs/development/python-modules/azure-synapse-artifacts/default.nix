{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0p43zmw96fh3wp75phf3fcqdfb36adqvxfc945yfda6fi555nw1a";
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
