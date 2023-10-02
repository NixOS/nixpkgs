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
  version = "5.0.7";
  pname = "icalendar";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    rev = "refs/tags/v${version}";
    hash = "sha256-fblcbyctnvd7DOc+tMWzg+90NHzZvH5xiY6BfJakQVo=";
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
