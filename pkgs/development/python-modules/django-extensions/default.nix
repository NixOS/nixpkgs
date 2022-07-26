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
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-jibske9cnOn4FPAGNs2EU1w1huF4dNxHAnOzuKSj3/E=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=django_extensions --cov-report html --cov-report term" ""
  '';

  propagatedBuildInputs = [
    django
  ];

  __darwinAllowLocalNetworking = true;

  checkInputs = [
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
