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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Gil0v4pGyp5+TnYPjb8Vk0xTqnQKaeD8Ko/ZWhvkbUk=";
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
