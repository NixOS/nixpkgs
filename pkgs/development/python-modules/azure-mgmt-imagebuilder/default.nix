{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-imagebuilder";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "634e398de9a23e712aa27a4a59f9ea5d5091d1dfcfed5ac977230918872c4430";
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
