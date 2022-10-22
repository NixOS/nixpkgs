{ lib
, fetchPypi
, buildPythonPackage
, django
, django_compat
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-hijack";
  version = "3.2.1";

  # the wheel comes with pre-built assets, allowing us to avoid fighting
  # with npm/webpack/gettext to build them ourselves.
  format = "wheel";
  src = fetchPypi {
    inherit version format;
    pname = "django_hijack";
    dist = "py3";
    python = "py3";
    sha256 = "sha256-sHI3ULJH5bH2n2AKQLHVEkBAYfM5GOC/+0qpKDFOods=";
  };

  propagatedBuildInputs = [ django django_compat ];

  checkInputs = [ pytestCheckHook pytest-django ];
  preCheck = ''
    export DJANGO_SETTINGS_MODULE='hijack.tests.test_app.settings'
  '';
  pytestFlagsArray = [ "--pyargs" "hijack" ];

  meta = with lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = "https://github.com/arteria/django-hijack";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
