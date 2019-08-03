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
  pname = "azure-mgmt-iotcentral";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "9aac88ed1f993965015f4e9986931fc08798e09d7b864928681a7cebff053de8";
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
    description = "This is the Microsoft Azure IoTCentral Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/iot?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
