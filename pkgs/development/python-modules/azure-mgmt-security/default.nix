{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "azure-mgmt-security";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f37d0151d730801222af111f0830905634795dbfd59ad1b89c35197421e74d3";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.security" ];

  meta = with lib; {
    description = "Microsoft Azure Security Center Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
