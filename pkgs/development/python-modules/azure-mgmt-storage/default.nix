{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, isPy3k
}:

buildPythonPackage rec {
  version = "8.0.0";
  pname = "azure-mgmt-storage";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0cxcdyy974ya1yi7s14sw54rwpc8qjngxr0jqb8vxki3528phrv3";
  };

  propagatedBuildInputs = [ azure-mgmt-common ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer olcai mwilsoninsight ];
  };
}
