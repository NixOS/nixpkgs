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
  version = "10.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f1216f505126483c568be511a3e0e654f886f13730dae5368609ff0573528cf2";
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
