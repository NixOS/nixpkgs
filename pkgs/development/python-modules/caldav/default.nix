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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m64maiqp3k8fsgkkvdx1dlfhkc70pqig4dclq6w8ajz82czrq83";
  };

  propagatedBuildInputs = [ six requests vobject lxml ]
    ++ lib.optionals (pythonOlder "3.6") [ pytz tzlocal ];

  checkInputs = [
    icalendar
    nose
    tzlocal
  ];

  # xandikos and radicale is only a optional test dependency, not available for python3
  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'xandikos'" "" \
      --replace ", 'radicale'" ""
  '';

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "This project is a CalDAV (RFC4791) client library for Python.";
    homepage = "https://pythonhosted.org/caldav/";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz ];
    #broken = true; # requires radicale which is not packaged yet
  };
}
