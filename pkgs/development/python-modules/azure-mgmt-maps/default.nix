{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-maps";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "384e17f76a68b700a4f988478945c3a9721711c0400725afdfcb63cf84e85f0e";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Maps Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
