{ lib
, buildPythonPackage
, fetchPypi
, tzlocal
, requests
, vobject
, lxml
, nose
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "0.7.0";

  propagatedBuildInputs = [ tzlocal requests vobject lxml nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5982b204fcfac8598381e35e46b667542bd728009971271463f81100e6e5943";
  };

  # xandikos is only a optional test dependency, not available for python3
  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'xandikos'" ""
  '';

  meta = with lib; {
    description = "This project is a CalDAV (RFC4791) client library for Python.";
    homepage = "https://pythonhosted.org/caldav/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz ];
  };
}
