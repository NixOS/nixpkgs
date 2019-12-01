{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, azure-common
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "azure-loganalytics";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3ceb350def677a351f34b0a0d1637df6be0c6fe87ff32a5270b17f540f6da06e";
  };

  propagatedBuildInputs = [
    msrest
    azure-common
  ];

  postInstall = lib.optionalString isPy3k ''
    rm -rf $out/${python.sitePackages}/azure/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/loganalytics/client?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
