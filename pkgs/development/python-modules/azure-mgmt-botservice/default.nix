{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "azure-mgmt-botservice";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "10sxllwvybjlp35h5mjdxhkw2wzpl4b03i08p4jnv8cswrc8h7dj";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.botservice" ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
