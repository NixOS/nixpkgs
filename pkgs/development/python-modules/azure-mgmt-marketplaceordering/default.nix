{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-nspkg,
  isPy3k,
  azure-mgmt-core,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-marketplaceordering";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "68b381f52a4df4435dacad5a97e1c59ac4c981f667dcca8f9d04453417d60ad8";
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
    description = "This is the Microsoft Azure Market Place Ordering Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
