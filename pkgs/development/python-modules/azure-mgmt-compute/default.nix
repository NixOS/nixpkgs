{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, azure-mgmt-core
}:

buildPythonPackage rec {
  version = "23.0.0";
  pname = "azure-mgmt-compute";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1eb26b965ba4049ddcf10d4f25818725fc03c491c3be76537d0d74ceb1146b04";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.compute" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
