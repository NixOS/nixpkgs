{ lib
, buildPythonPackage
, fetchPypi
, python
, msrest
, msrestazure
, azure-common
, isPy27
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "azure-mgmt-redhatopenshift";
  disabled = isPy27; # don't feel like fixing namespace issues on python2

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1g65lbia1i1jw6qkyjz2ldyl3p90rbr78l8kfryg70sj7z3gnnjn";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
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
