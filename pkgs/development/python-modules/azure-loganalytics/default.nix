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
    hash = "sha256-aP+5oiBuBrlnIQCo5jUcwE91u4GGfzDUFsaLVdYk15M=";
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
