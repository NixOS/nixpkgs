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
  pname = "azure-mgmt-monitor";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "09bhk6kpf1j1kgsyfdrfmfixrdj0iikx25dr1mh9dc6lci07i1cx";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm -rf $out/${python.sitePackages}/azure/__init__.py
    rm -rf $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Monitor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
