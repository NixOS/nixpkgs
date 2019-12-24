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
  pname = "azure-mgmt-maps";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c120e210bb61768da29de24d28b82f8d42ae24e52396eb6569b499709e22f006";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py
    rm $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Maps Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-mgmt-maps;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
