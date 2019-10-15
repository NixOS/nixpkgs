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
  pname = "azure-mgmt-trafficmanager";
  version = "0.51.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "fc8ae77022cfe52fda4379a2f31e0b857574d536e41291a7b569b5c0f4104186";
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
    description = "This is the Microsoft Azure Traffic Manager Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/traffic-manager?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
