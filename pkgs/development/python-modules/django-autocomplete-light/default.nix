{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, six
, pytestCheckHook
, django-debug-toolbar
, django-extensions
, django-taggit
, django-tagging
, mock
, pytest-django
, selenium
, splinter
, sqlparse
, tenacity
, whitenoise
}:

buildPythonPackage rec {
  pname = "django-autocomplete-light";
  version = "3.9.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "yourlabs";
    repo = "django-autocomplete-light";
    rev = version;
    hash = "sha256-YUiGN6q7ARM/rg7d+ykeDEYZDYjB+DHxMCmdme6QccU=";
  };

  propagatedBuildInputs = [
    django
    six
  ];

  # Too many un-packaged dependencies
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    django-debug-toolbar
    django-extensions
    django-taggit
    django-tagging
    mock
    pytest-django
    selenium
    splinter
    sqlparse
    tenacity
    whitenoise

    # FIXME: not packaged
    # django-generic-m2m
    # django-gm2m
    # django-querysetsequence
    # pytest-splinter
    # dango-nested-admin
    # djhacker
  ];

  # Taken from tox.ini
  preCheck = "cd test_project";

  pythonImportsCheck = [ "dal" ];

  meta = with lib; {
    description = "A fresh approach to autocomplete implementations, specially for Django";
    homepage = "https://django-autocomplete-light.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ambroisie ];
  };
}
