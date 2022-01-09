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
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-NAMa78KhAuoJfp0Cb0Codz84sRfRQ1JhSLNYRI4GBPM=";
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
