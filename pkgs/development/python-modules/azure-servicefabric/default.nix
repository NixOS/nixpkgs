{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  msrest,
}:

buildPythonPackage rec {
  pname = "azure-servicefabric";
  version = "8.2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-9JyHWUR5cIF7my09S5dDl2Xc91ugG2Bmzpa2BQUvuyM=";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This project provides a client library in Python that makes it easy to consume Microsoft Azure Storage services";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
