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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "hZ6GS2VkXH8KfKZuL1rR6JS/nDkx8SfKuUx5XrvTbec=";
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

  # remove tests that need network access
  checkPhase = ''
    rm tests/management/commands/test_pipchecker.py
    DJANGO_SETTINGS_MODULE=tests.testapp.settings \
      pytest django_extensions tests
  '';

  meta = with lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = "https://github.com/django-extensions/django-extensions";
    license = licenses.mit;
  };
}
