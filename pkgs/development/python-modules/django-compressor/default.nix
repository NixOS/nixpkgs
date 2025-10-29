{
  lib,
  buildPythonPackage,
  fetchPypi,

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
  version = "4.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "django_compressor";
    inherit version;
    hash = "sha256-wdikii7k2LfyPEEeucl+LYjbGKGLocnoF41fW4NmqCI=";
  };

  patches = [
    # https://github.com/django-compressor/django-compressor/issues/1279
    # https://github.com/django-compressor/django-compressor/pull/1296
    ./bs4-4.13-compat.patch
  ];

  build-system = [
    setuptools
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
  };
}
