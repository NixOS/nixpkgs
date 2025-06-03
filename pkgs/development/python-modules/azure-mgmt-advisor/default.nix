{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  isPy3k,
  azure-mgmt-core,
  azure-mgmt-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-advisor";
  version = "9.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "fc408b37315fe84781b519124f8cb1b8ac10b2f4241e439d0d3e25fd6ca18d7b";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ] ++ lib.optionals (!isPy3k) [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Advisor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
