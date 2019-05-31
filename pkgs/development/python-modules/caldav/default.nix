{ lib, buildPythonPackage, fetchPypi
, tzlocal, requests, vobject, lxml }:

buildPythonPackage rec {
  pname = "caldav";
  version = "0.6.0";

  propagatedBuildInputs = [ tzlocal requests vobject lxml ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ll9knpc50yxx858hrvfnapdi2a6g1pz9cnjhwffry2x7r4ckarz";
  };

  meta = with lib; {
    description = "This project is a CalDAV (RFC4791) client library for Python.";
    homepage = "https://pythonhosted.org/caldav/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz ];
  };
}
