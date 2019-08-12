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
  pname = "azure-mgmt-web";
  version = "0.42.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0vp40i9aaw5ycz7s7qqir6jq7327f7zg9j9i8g31qkfl1h1c7pdn";
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
    description = "This is the Microsoft Azure Web Apps Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/webapps?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
