{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-batch";
  version = "11.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "ce5fdb0ec962eddfe85cd82205e9177cb0bbdb445265746e38b3bbbf1f16dc73";
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
