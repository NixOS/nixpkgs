{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-policyinsights";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "75103fb4541aeae30bb687dee1fedd9ca65530e6b97b2d9ea87f74816905202a";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ]
  ++ lib.optionals (!isPy3k) [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.policyinsights" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Policy Insights Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
