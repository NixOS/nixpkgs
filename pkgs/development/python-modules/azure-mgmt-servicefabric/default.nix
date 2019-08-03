{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicefabric";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b2bf2279b8ff8450c35e78e226231655021482fdbda27db09975ebfc983398ad";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Service Fabric Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/servicefabric?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
