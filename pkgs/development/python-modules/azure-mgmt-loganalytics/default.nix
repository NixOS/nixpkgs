{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-loganalytics";
  version = "12.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "da128a7e0291be7fa2063848df92a9180cf5c16d42adc09d2bc2efd711536bfb";
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

  pythonImportsCheck = [ "azure.mgmt.loganalytics" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Log Analytics Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
