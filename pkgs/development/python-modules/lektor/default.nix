{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, filetype
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
, python-slugify
, isPy27
, functools32
, setuptools
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = "lektor";
    rev = "v${version}";
    sha256 = "sha256-PNHQ87aO+b1xseupIOsO7MXdr16s0gjoHGnZhPlKKRY=";
  };

  propagatedBuildInputs = [
    click filetype watchdog exifread requests mistune inifile Babel jinja2
    flask pyopenssl python-slugify ndg-httpsclient setuptools
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
