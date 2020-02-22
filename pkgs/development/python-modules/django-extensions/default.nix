{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, python
, django
, factory_boy
, glibcLocales
, mock
, pygments
, pytest
, pytestcov
, pytest-django
, python-dateutil
, shortuuid
, six
, tox
, typing
, vobject
, werkzeug
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1gd3nykwzh3azq1p9cvgkc3l5dwrv7y86sfjxd9llbyj8ky71iaj";
  };

  LC_ALL = "en_US.UTF-8";
  __darwinAllowLocalNetworking = true;

  propagatedBuildInputs = [ six ]
    ++ lib.optional (pythonOlder "3.5") typing;

  checkInputs = [
    django
    factory_boy
    glibcLocales
    mock
    pygments # not explicitly declared in setup.py, but some tests require it
    pytest
    pytestcov
    pytest-django
    python-dateutil
    shortuuid
    tox
    vobject
    werkzeug
  ];

  # tests not compatible with pip>=20
  checkPhase = ''
    rm tests/management/commands/test_pipchecker.py
    ${python.interpreter} setup.py test
  '';

  meta = with lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = "https://github.com/django-extensions/django-extensions";
    license = licenses.mit;
  };
}
