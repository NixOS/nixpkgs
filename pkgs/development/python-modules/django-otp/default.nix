{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  freezegun,
  qrcode,
  pytest,
  python,
}:

buildPythonPackage rec {
  pname = "django-otp";
<<<<<<< HEAD
  version = "1.6.3";
=======
  version = "1.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-otp";
    repo = "django-otp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-sYwt41YWQQN6nKXGmrrZ75t/i1XNVjIgRKVElVaCGRc=";
=======
    hash = "sha256-//i2KSsrkofcNE2JUlIG9zPCe/cIzBo/zmueC4I5g7I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    qrcode
  ];

  env.DJANGO_SETTINGS_MODUOLE = "test.test_project.settings";

  nativeCheckInputs = [
    freezegun
    pytest
  ];

  checkPhase = ''
    runHook preCheck

    export PYTHONPATH=$PYTHONPATH:test
    export DJANGO_SETTINGS_MODULE=test_project.settings
    ${python.interpreter} -m django test django_otp

    runHook postCheck
  '';

  enabledTestPaths = [ "src/django_otp/test.py" ];

  pythonImportsCheck = [ "django_otp" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/django-otp/django-otp";
    changelog = "https://github.com/django-otp/django-otp/blob/${src.tag}/CHANGES.rst";
    description = "Pluggable framework for adding two-factor authentication to Django using one-time passwords";
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    homepage = "https://github.com/django-otp/django-otp";
    changelog = "https://github.com/django-otp/django-otp/blob/${src.tag}/CHANGES.rst";
    description = "Pluggable framework for adding two-factor authentication to Django using one-time passwords";
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
