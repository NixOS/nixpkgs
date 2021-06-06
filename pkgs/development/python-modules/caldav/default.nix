{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, icalendar
, lxml
, mock
, nose
, pytz
, requests
, six
, tzlocal
, vobject
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "v${version}";
    sha256 = "11q3svns3a2ywfci739krxbh67cx691qja772wq22606blyygyjy";
  };

  nativeBuildInputs = lib.optionals (pythonOlder "3.5") [ mock ];
  propagatedBuildInputs = [ six requests vobject lxml ]
    ++ lib.optionals (pythonOlder "3.6") [ pytz tzlocal ];

  checkInputs = [
    icalendar
    nose
    tzlocal
  ];

  checkPhase = ''
    nosetests tests
  '';

  # xandikos and radicale is only a optional test dependency, not available for python3
  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'xandikos'" "" \
      --replace ", 'radicale'" ""
  '';

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "This project is a CalDAV (RFC4791) client library for Python.";
    homepage = "https://github.com/python-caldav/caldav";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz ];
    #broken = true; # requires radicale which is not packaged yet
  };
}
