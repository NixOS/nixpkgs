{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, lxml
, nose
, pytestCheckHook
, pythonOlder
, pytz
, requests
, six
, tzlocal
, vobject
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BghBuzeA2YpUwX2IeU3YF13ur0Vc5KfOTmVkfs69oEQ=";
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
    pytestCheckHook
    pytz
    tzlocal
  ];

  # xandikos and radicale is only a optional test dependency, not available for Python 3
  postPatch = ''
    substituteInPlace setup.py \
      --replace '"xandikos<0.2.4",' "" \
      --replace '"radicale",' ""
  '';

  pythonImportsCheck = [
    "caldav"
  ];

  meta = with lib; {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    license = with licenses; [ asl20 gpl3Only ];
    maintainers = with maintainers; [ marenz dotlambda ];
  };
}
