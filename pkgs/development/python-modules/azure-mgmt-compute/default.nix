{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, azure-mgmt-core
, isPy3k
}:

buildPythonPackage rec {
  version = "17.0.0";
  pname = "azure-mgmt-compute";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c7350b404e5d10a548ceddb034394c8fad6c852ce33a3d3b211065813c1da404";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
