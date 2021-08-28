{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, azure-mgmt-core
}:

buildPythonPackage rec {
  version = "20.0.0";
  pname = "azure-mgmt-compute";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7920bea2e11d78fa616992813aea470a8fb50eab2e646e032e138f93d53b70e8";
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
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
