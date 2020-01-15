{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-policyinsights";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b27f5ac367b69e225ab02fa2d1ea20cbbfe948ff43b0af4698cd8cbde0063908";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Policy Insights Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/policy?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
