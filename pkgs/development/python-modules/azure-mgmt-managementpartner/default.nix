{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-managementpartner";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1bvcmx7dkf2adi26z7c2ga63ggpzdfqj8q1gzcic1yn03v6nb8i7";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure ManagementPartner Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
