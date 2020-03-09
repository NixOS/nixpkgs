{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicefabric";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1x18grkjf2p2r1ihlwv607sna9yjvsr2jwnkjc55askrgrwx5jx2";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # this is still needed for overriding to previous versions
  # E.g azure-cli
  postInstall = lib.optionalString isPy3k ''
    rm -f $out/${python.sitePackages}/azure/{,mgmt/}__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Service Fabric Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
