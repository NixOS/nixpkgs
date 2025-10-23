{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-appconf";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "django-compressor";
    repo = "django-appconf";
    tag = "v${version}";
    hash = "sha256-raK3Q+6cDSOiK5vrgZG65qDUiFOrRhDKxsPOQv/lz8w=";
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

  meta = with lib; {
    description = "Helper class for handling configuration defaults of packaged apps gracefully";
    homepage = "https://django-appconf.readthedocs.org/";
    changelog = "https://github.com/django-compressor/django-appconf/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd2;
  };
}
