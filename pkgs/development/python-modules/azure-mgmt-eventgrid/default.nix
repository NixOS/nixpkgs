{ lib, buildPythonPackage, fetchPypi, msrest, msrestazure, azure-common
, azure-mgmt-core, azure-mgmt-nspkg, isPy3k }:

buildPythonPackage rec {
  pname = "azure-mgmt-eventgrid";
  version = "10.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "582e314ca05a9be0cd391c64689e6a5332d5bbad76c2ea751b727cfe99a2a3d2";
  };

  propagatedBuildInputs = [ msrest msrestazure azure-mgmt-core azure-common ]
    ++ lib.optionals (!isPy3k) [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.eventgrid" ];

  meta = with lib; {
    description =
      "This is the Microsoft Azure EventGrid Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
