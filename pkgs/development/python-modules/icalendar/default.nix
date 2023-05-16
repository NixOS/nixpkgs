{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, backports-zoneinfo
, python-dateutil
, pytz
, hypothesis
, pytest
}:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "5.0.7";
=======
  version = "5.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "icalendar";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-fblcbyctnvd7DOc+tMWzg+90NHzZvH5xiY6BfJakQVo=";
=======
    hash = "sha256-Ch0i6hxEnHV/Xu4PqpRVt30KLOHHgtCAI2W9UyXo15E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    hypothesis
    pytest
  ];

  meta = with lib; {
    changelog = "https://github.com/collective/icalendar/blob/v${version}/CHANGES.rst";
    description = "A parser/generator of iCalendar files";
    homepage = "https://github.com/collective/icalendar";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };

}
