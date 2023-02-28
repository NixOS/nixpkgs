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
  version = "3.2.6";

  # the wheel comes with pre-built assets, allowing us to avoid fighting
  # with npm/webpack/gettext to build them ourselves.
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "django_hijack";
    dist = "py3";
    python = "py3";
    hash = "sha256-xFPZ03II1814+bZ5gx7GD/AxYMiLuH6awfSeXEraOHQ=";
  };

  propagatedBuildInputs = [
    django
    django_compat
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE='hijack.tests.test_app.settings'
  '';

  pytestFlagsArray = [
    "--pyargs"
    "hijack"
  ];

  meta = with lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = "https://github.com/arteria/django-hijack";
    changelog = "https://github.com/django-hijack/django-hijack/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
