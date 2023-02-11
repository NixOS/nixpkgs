{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, factory_boy
, mock
, pygments
, pytest-django
, pytestCheckHook
, shortuuid
, vobject
, werkzeug
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-i8A/FMba1Lc3IEBzefP3Uu23iGcDGYqo5bNv+u6hKQI=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=django_extensions --cov-report html --cov-report term" ""
  '';

  propagatedBuildInputs = [
    django
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    factory_boy
    mock
    pygments # not explicitly declared in setup.py, but some tests require it
    pytest-django
    pytestCheckHook
    shortuuid
    vobject
    werkzeug
  ];

  disabledTestPaths = [
    # requires network access
    "tests/management/commands/test_pipchecker.py"
  ];

  meta = with lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = "https://github.com/django-extensions/django-extensions";
    license = licenses.mit;
  };
}
