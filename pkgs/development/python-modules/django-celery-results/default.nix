{
  lib,
  stdenv,
  fetchPypi,
  fetchpatch,
  buildPythonPackage,
  setuptools,
  celery,
  django,
  postgresqlTestHook,
  postgresql,
  pytestCheckHook,
  pytest-django,
  pytz,
  psycopg,
  psycopg2cffi,
}:

buildPythonPackage rec {
  pname = "django-celery-results";
  version = "2.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_celery_results";
    inherit version;
    hash = "sha256-mrzYNq5rYQY3eSRNiIeoj+gLv6uhQ98208sHA0ZxJ3w=";
  };

  patches = [
    # Needed to fix some `AttributeError`s during tests
    (fetchpatch {
      name = "fix-attribute-error.patch";
      url = "https://github.com/celery/django-celery-results/commit/067dfc9a857344c833e269f679047d48b938e60d.patch?full_index=1";
      hash = "sha256-IHwzd91rAsgjJblnQ8lLMRVH3GZfPuK8phDAGYj6HUY=";
    })
  ];

  postPatch = ''
    # Drop malformatted tests_require specification
    sed -i '/tests_require=/d' setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    celery
    django
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    pytz
    psycopg
    psycopg2cffi
    postgresqlTestHook
    postgresql
  ];

  disabledTestPaths = [
    # Only benchmarks, which we don't care about
    "t/integration"
  ];

  # Can't connect to the test db with a unix socket for some reason, so use TCP instead
  postgresqlEnableTCP = true;

  # postgresqlTestHook doesn't work on darwin.
  doCheck = lib.meta.availableOn stdenv.buildPlatform postgresqlTestHook;

  meta = {
    description = "Celery result back end with django";
    homepage = "https://github.com/celery/django-celery-results";
    changelog = "https://github.com/celery/django-celery-results/blob/v${version}/Changelog";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
