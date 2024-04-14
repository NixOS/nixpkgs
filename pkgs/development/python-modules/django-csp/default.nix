{ lib
, fetchPypi
, buildPythonPackage

# build-system
, setuptools

# dependencies
, django

# tests
, jinja2
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-csp";
  version = "3.8";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "django_csp";
    hash = "sha256-7w8an32Nporm4WnALprGYcDs8E23Dg0dhWQFEqaEccA=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  nativeCheckInputs = [
    jinja2
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Adds Content-Security-Policy headers to Django";
    homepage = "https://github.com/mozilla/django-csp";
    license = licenses.bsd3;
  };
}
