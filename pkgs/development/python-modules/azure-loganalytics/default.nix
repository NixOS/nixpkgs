{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  azure-common,
}:

buildPythonPackage rec {
  version = "0.1.1";
  format = "setuptools";
  pname = "azure-loganalytics";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "68ffb9a2206e06b9672100a8e6351cc04f75bb81867f30d416c68b55d624d793";
  };

  propagatedBuildInputs = [
    msrest
    azure-common
  ];

  pythonNamespaces = [ "azure" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      maxwilson
    ];
  };
}
