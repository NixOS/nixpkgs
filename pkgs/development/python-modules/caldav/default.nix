{ lib, buildPythonPackage, fetchPypi
, tzlocal, requests, vobject, lxml, nose }:

buildPythonPackage rec {
  pname = "caldav";
  version = "0.6.1";

  propagatedBuildInputs = [ tzlocal requests vobject lxml nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "eddb7f4e6a3eb5f02eaa2227817a53ac4372d4c4d51876536f4c6f00282f569e";
  };

  meta = with lib; {
    description = "This project is a CalDAV (RFC4791) client library for Python.";
    homepage = "https://pythonhosted.org/caldav/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz ];
  };
}
