{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, watchdog
, exifread
, requests
, mistune
, inifile
, Babel
, jinja2
, flask
, pyopenssl
, ndg-httpsclient
, pytest
, pytestcov
, pytest-mock
, pytest-pylint
, pytest-click
, isPy27
, functools32
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = "lektor";
    rev = version;
    sha256 = "16qw68rz5q77w84lwyhjpfd3bm4mfrhcjrnxwwnz3vmi610h68hx";
  };

  propagatedBuildInputs = [
    click watchdog exifread requests mistune inifile Babel jinja2
    flask pyopenssl ndg-httpsclient
  ] ++ lib.optionals isPy27 [ functools32 ];

  checkInputs = [
    pytest pytestcov pytest-mock pytest-pylint pytest-click
  ];

  checkPhase = ''
    pytest
  '';

  # many errors -- tests assume inside of git repo, linting errors 13/317 fail
  doCheck = false;

  meta = with lib; {
    description = "A static content management system";
    homepage    = "https://www.getlektor.com/";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ vozz costrouc ];
  };

}
