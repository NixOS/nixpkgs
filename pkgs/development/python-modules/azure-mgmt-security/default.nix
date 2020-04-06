{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "azure-mgmt-security";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z766424783a6y5dp5ybxssb0bfzqb8kpa6zra8ccnbfg4fn478v";
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
