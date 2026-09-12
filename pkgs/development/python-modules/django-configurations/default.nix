{
  lib,
  buildPythonPackage,
  dj-database-url,
  dj-email-url,
  dj-search-url,
  django,
  django-cache-url,
  fetchPypi,
  fetchpatch,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-configurations";
  version = "2.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-blCDdX4rvfm7eFBWdTa5apNRX2sXUD10ko/2KNsuDpQ=";
  };

  patches = [
    # The `DISABLE_SERVER_SIDE_CURSORS` setting is new to django 6 and without this patch test a dict-equality test fails
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/jazzband/django-configurations/commit/63cac8d54eed7267e208556838499e41cb30f658.patch?full_index=1";
      hash = "sha256-xXDl2fSF+PglDERtp4/SJ8QIoy8zLD8ly4JZoLH8Vco=";
    })
  ];

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  nativeCheckInputs = [
    dj-database-url
    dj-email-url
    dj-search-url
    django-cache-url
    unittestCheckHook
  ];

  checkPhase = ''
    export PYTHONPATH=.:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE="tests.settings.main"
    export DJANGO_CONFIGURATION="Test"
    $out/bin/django-cadmin test -v2
  '';

  pythonImportsCheck = [ "configurations" ];

  meta = {
    description = "Helper for organizing Django settings";
    mainProgram = "django-cadmin";
    homepage = "https://django-configurations.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
