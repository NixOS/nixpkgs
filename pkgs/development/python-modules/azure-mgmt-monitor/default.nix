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
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1pprvk5255b6brbw73g0g13zygwa7a2px5x08wy3153rqlzan5l2";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm -f $out/${python.sitePackages}/azure/__init__.py
    rm -f $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Monitor Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/monitoring?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
