{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-mgmt-extendedlocation";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-jRo6EFP8Dg3i9U8HLfjED9QFfWbdg+X3o9PSf4eus9o=";
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
