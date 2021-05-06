{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, azure-mgmt-core
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cdn";
  version = "11.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "28e7070001e7208cdb6c2ad253ec78851abdd73be482230d2c0874eed5bc0907";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure CDN Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
