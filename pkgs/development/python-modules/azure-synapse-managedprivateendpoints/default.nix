{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-managedprivateendpoints";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "900eaeaccffdcd01012b248a7d049008c92807b749edd1c9074ca9248554c17e";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonNamespaces = [ "azure.synapse" ];

  pythonImportsCheck = [ "azure.synapse.managedprivateendpoints" ];

  meta = with lib; {
    description = "Microsoft Azure Synapse Managed Private Endpoints Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
