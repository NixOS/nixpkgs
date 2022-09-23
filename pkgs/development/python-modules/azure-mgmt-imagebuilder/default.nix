{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "azure-mgmt-imagebuilder";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2EWfTsl5y3Sw4P8d5X7TKxYmO4PagUTNv/SFKdjY2Ss=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.core"
    "azure.mgmt.imagebuilder"
  ];

  meta = with lib; {
    description = "Microsoft Azure Image Builder Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
