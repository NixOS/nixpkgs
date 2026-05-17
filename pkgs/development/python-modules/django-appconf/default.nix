{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-appconf";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-compressor";
    repo = "django-appconf";
    tag = "v${version}";
    hash = "sha256-kpytEpvibnumkQGfHBDKA0GzSB0R8o0g0f51Rv6KEhA=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  preCheck = ''
    # prove we're running tests against installed package, not build dir
    rm -r appconf
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m django test --settings=tests.test_settings

    runHook postCheck
  '';

  pythonImportsCheck = [ "appconf" ];

  meta = {
    description = "Helper class for handling configuration defaults of packaged apps gracefully";
    homepage = "https://django-appconf.readthedocs.org/";
    changelog = "https://github.com/django-compressor/django-appconf/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.bsd2;
  };
}
