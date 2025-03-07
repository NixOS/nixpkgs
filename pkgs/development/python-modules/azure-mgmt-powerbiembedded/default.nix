{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-powerbiembedded";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "2f05be73f2a086c579a78fc900e3b2ae14ccde5bcec54e29dfc73e626b377476";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Power BI Embedded Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
