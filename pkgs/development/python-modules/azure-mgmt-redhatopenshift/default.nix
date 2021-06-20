{ lib
, buildPythonPackage
, fetchPypi
, python
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, isPy27
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-redhatopenshift";
  disabled = isPy27; # don't feel like fixing namespace issues on python2

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "94cd41f1ebd82e40620fd3e6d88f666b5c19ac7cf8b4e8edadb9721bd7c80980";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = "azure.mgmt";

  # no included
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.redhatopenshift" ];

  meta = with lib; {
    description = "Microsoft Azure Red Hat Openshift Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
