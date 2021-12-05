{ lib, buildPythonPackage, fetchPypi, isPy3k, msrest, msrestazure, azure-common
, azure-mgmt-core, azure-mgmt-nspkg }:

buildPythonPackage rec {
  pname = "azure-mgmt-monitor";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "91ddb7333bf2b9541a53864cc8d2501e3694a03a9c0e41cbfae3348558675ce6";
  };

  propagatedBuildInputs = [ msrest msrestazure azure-common azure-mgmt-core ]
    ++ lib.optionals (!isPy3k) [ azure-mgmt-nspkg ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Monitor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
