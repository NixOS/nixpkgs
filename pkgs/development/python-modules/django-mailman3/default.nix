{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # build-system
  pdm-backend,

  # dependencies
  django-gravatar2,
  django-allauth,
  mailmanclient,
  pytz,

  # tests
  django,
  pytest-django,
  pytestCheckHook,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.15";
  pyproject = true;

  src = fetchPypi {
    pname = "django_mailman3";
    inherit version;
    hash = "sha256-+ZFrJpy5xdW6Yde/XEvxoAN8+TSQdiI0PfjZ7bHG0Rs=";
  };

  patches = [
    (fetchpatch {
      name = "django-5.2.patch";
      url = "https://gitlab.com/mailman/django-mailman3/-/commit/465c1ffc77556bb8a80a678f53a40f16b9766cc6.patch";
      excludes = [
        ".gitlab-ci.yml"
        "README.rst"
      ];
      hash = "sha256-gSFczuNLlMclqixOu6ElS0BewUTGyhP6RXtE/waLzyo=";
    })

    (fetchpatch {
      # Only needed so the next one applies.
      name = "allauth-64-1.patch";
      url = "https://gitlab.com/mailman/django-mailman3/-/commit/96f3f3bf0c718395ccd1b0d539a40d627522a9c4.patch";
      hash = "sha256-xgQu70DkbPz+ULRFgKeJTbx/Tq2PLEyGgrncf26ChA4=";
    })
    (fetchpatch {
      name = "allauth-64-2.patch";
      url = "https://gitlab.com/mailman/django-mailman3/-/commit/cfdacb9195ce266e5ae23307b31304898369f696.patch";
      hash = "sha256-6mwGSw31Q0+APwdGFe0JE0gBigdo453HZZ6JApqgtTE=";
    })
  ];

  pythonRelaxDeps = [ "django-allauth" ];

  build-system = [ pdm-backend ];

  dependencies = [
    django-allauth
    django-gravatar2
    mailmanclient
    pytz
  ]
  ++ django-allauth.optional-dependencies.openid
  ++ django-allauth.optional-dependencies.socialaccount;

  nativeCheckInputs = [
    django
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=django_mailman3.tests.settings_test
  '';

  pythonImportsCheck = [ "django_mailman3" ];

  passthru.tests = {
    inherit (nixosTests) mailman;
  };

  meta = {
    description = "Django library for Mailman UIs";
    homepage = "https://gitlab.com/mailman/django-mailman3";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ qyliss ];
    broken = lib.versionAtLeast django.version "5.3";
  };
}
