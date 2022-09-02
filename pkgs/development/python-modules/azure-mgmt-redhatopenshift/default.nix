{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, isPy27
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "azure-mgmt-redhatopenshift";
  disabled = isPy27; # don't feel like fixing namespace issues on python2

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-Tq8h3fvajxIG2QjtCyHCQDE2deBDioxLLaQQek/O24U=";
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
