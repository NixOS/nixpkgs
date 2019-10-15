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
  pname = "azure-mgmt-containerservice";
  version = "7.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "104w7rxv7hy84yzddbbpkjqha04ghr0zz9qy788n3wl69cj4cv1a";
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
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-containerservice;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
