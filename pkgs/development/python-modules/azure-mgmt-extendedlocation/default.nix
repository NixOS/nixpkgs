{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-mgmt-extendedlocation";
  version = "1.0.0b2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-mjfH35T81JQ97jVgElWmZ8P5MwXVxZQv/QJKNLS3T8A=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  pythonImportsCheck = [ "azure.mgmt.extendedlocation" ];

  meta = with lib; {
    description = "Microsoft Azure Extendedlocation Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
