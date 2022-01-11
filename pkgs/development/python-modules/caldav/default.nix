{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, icalendar
, lxml
, nose
, pytz
, requests
, six
, tzlocal
, vobject
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2mpE1aLipps4X/3EF0oKHXDcrgUh78/fxY6y1B1V2IU=";
  };

  propagatedBuildInputs = [
    vobject
    lxml
    requests
    six
  ];

  checkInputs = [
    icalendar
    nose
    tzlocal
    pytz
  ];

  checkPhase = ''
    nosetests tests
  '';

  # xandikos and radicale is only a optional test dependency, not available for python3
  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'xandikos<0.2.4'" "" \
      --replace ", 'radicale'" ""
  '';

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "This project is a CalDAV (RFC4791) client library for Python.";
    homepage = "https://github.com/python-caldav/caldav";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz dotlambda ];
  };
}
