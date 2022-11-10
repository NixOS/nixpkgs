{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-batch";
  version = "13.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-6Sld5wQE0nbtoN0iU9djl0Oavl2PGMH8oZnEm41q4wo=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.batch" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Batch Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
