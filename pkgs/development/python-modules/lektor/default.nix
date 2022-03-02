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
, pytestCheckHook
, pytest-cov
, pytest-mock
, pytest-pylint
, pytest-click
, isPy27
, functools32
, setuptools
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = "lektor";
    rev = version;
    sha256 = "sha256-PNHQ87aO+b1xseupIOsO7MXdr16s0gjoHGnZhPlKKRY=";
  };

  propagatedBuildInputs = [
    click watchdog exifread requests mistune inifile Babel jinja2
    flask pyopenssl ndg-httpsclient setuptools
  ] ++ lib.optionals isPy27 [ functools32 ];

  checkInputs = [
    pytestCheckHook pytest-cov pytest-mock pytest-pylint pytest-click
  ];

  # many errors -- tests assume inside of git repo, linting errors 13/317 fail
  doCheck = false;

  meta = with lib; {
    description = "A static content management system";
    homepage    = "https://www.getlektor.com/";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ costrouc ];
  };

}
