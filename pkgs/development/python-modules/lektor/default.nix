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
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = "lektor";
    rev = version;
    sha256 = "04gn3jybqf9wc6l9mi0djpki60adnk7gppmv987ik676k5x8f1kk";
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
