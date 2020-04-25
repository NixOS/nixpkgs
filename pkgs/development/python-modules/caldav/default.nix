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
  version = "0.6.2";

  propagatedBuildInputs = [ tzlocal requests vobject lxml nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "80c33b143539da3a471148ac89512f67d9df3a5286fae5a023e2ad3923246c0d";
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
