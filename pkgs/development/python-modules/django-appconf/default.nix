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
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "django-compressor";
    repo = "django-appconf";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kpytEpvibnumkQGfHBDKA0GzSB0R8o0g0f51Rv6KEhA=";
=======
    hash = "sha256-raK3Q+6cDSOiK5vrgZG65qDUiFOrRhDKxsPOQv/lz8w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Helper class for handling configuration defaults of packaged apps gracefully";
    homepage = "https://django-appconf.readthedocs.org/";
    changelog = "https://github.com/django-compressor/django-appconf/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    description = "Helper class for handling configuration defaults of packaged apps gracefully";
    homepage = "https://django-appconf.readthedocs.org/";
    changelog = "https://github.com/django-compressor/django-appconf/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
