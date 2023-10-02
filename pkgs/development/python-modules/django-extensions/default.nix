{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, django
, factory_boy
, mock
, pip
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
    hash = "sha256-i8A/FMba1Lc3IEBzefP3Uu23iGcDGYqo5bNv+u6hKQI=";
  };

  patches = [
    (fetchpatch {
      # pygments 2.14 compat for tests
      url = "https://github.com/django-extensions/django-extensions/commit/61ebfe38f8fca9225b41bec5418e006e6a8815e1.patch";
      hash = "sha256-+sxaQMmKi/S4IlfHqARPGhaqc+F1CXUHVFyeU/ArW2U=";
    })
  ];

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
    pip
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
