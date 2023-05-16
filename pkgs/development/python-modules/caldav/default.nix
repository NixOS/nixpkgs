{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, lxml
, pytestCheckHook
, pythonOlder
, pytz
, recurring-ical-events
, requests
, tzlocal
, vobject
}:

buildPythonPackage rec {
  pname = "caldav";
<<<<<<< HEAD
  version = "1.3.6";
=======
  version = "1.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-N3pY3UYxOZgZbXqqsvASej12dOtdpyEHOL10btOKm/w=";
=======
    hash = "sha256-nA7if28M4rDZwlF+ga/1FqD838zeu0OblrPUer3w3qM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    vobject
    lxml
    requests
    icalendar
    recurring-ical-events
<<<<<<< HEAD
    pytz
    tzlocal
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
=======
    tzlocal
    pytz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # xandikos and radicale are only optional test dependencies, not available for python3
  postPatch = ''
    substituteInPlace setup.py \
      --replace xandikos "" \
      --replace radicale ""
  '';

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    changelog = "https://github.com/python-caldav/caldav/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz dotlambda ];
  };
}
