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
  pname = "azure-mgmt-cdn";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0cdbe0914aec544884ef681e31950efa548d9bec6d6dc354e00c3dbdab9e76e3";
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
    description = "This is the Microsoft Azure CDN Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-cdn;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
