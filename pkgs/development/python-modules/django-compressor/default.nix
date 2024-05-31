{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,

  # build-system
  setuptools,

  # dependencies
  calmjs,
  django-appconf,
  jinja2,
  rcssmin,
  rjsmin,

  # tests
  beautifulsoup4,
  brotli,
  csscompressor,
  django-sekizai,
  pytestCheckHook,
  pytest-django,

}:

buildPythonPackage rec {
  pname = "django-compressor";
  version = "4.4";
  pyproject = true;

  src = fetchPypi {
    pname = "django_compressor";
    inherit version;
    hash = "sha256-GwrMnPup9pvDjnxB2psNcKILyVWHtkP/75YJz0YGT2c=";
  };

  build-system = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "rcssmin"
    "rjsmin"
  ];

  dependencies = [
    beautifulsoup4
    calmjs
    django-appconf
    jinja2
    rcssmin
    rjsmin
  ];

  env.DJANGO_SETTINGS_MODULE = "compressor.test_settings";

  nativeCheckInputs = [
    beautifulsoup4
    brotli
    csscompressor
    django-sekizai
    pytestCheckHook
    pytest-django
  ];

  # Getting error: compressor.exceptions.OfflineGenerationError: You have
  # offline compression enabled but key "..." is missing from offline manifest.
  # You may need to run "python manage.py compress"
  disabledTestPaths = [ "compressor/tests/test_offline.py" ];

  pythonImportsCheck = [ "compressor" ];

  meta = with lib; {
    description = "Compresses linked and inline JavaScript or CSS into single cached files";
    homepage = "https://django-compressor.readthedocs.org/";
    changelog = "https://github.com/django-compressor/django-compressor/blob/${version}/docs/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };
}
