{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "azure-mgmt-imagebuilder";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r4sxr3pbcci5qif1ip1lrix3cryj0b3asqch3zds4q705jiakc4";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.imagebuilder" ];

  meta = with lib; {
    description = "Microsoft Azure Image Builder Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
