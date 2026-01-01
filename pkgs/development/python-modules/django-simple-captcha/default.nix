{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  django-ranged-response,
  pillow,

  # tests
  flite,
  pytest-django,
  pytestCheckHook,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "django-simple-captcha";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.6.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-simple-captcha";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Fee7YfIWGyKMsN7XQz10bjIhbjUYRuY7Oe4Q8n8ILz0=";
=======
    hash = "sha256-hOvZQCAAlMYaNpAN+junhfgWej92shto7ejhKUPqbX0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pillow
    django-ranged-response
  ];

  nativeCheckInputs = [
    flite
    pytest-django
    pytestCheckHook
    testfixtures
  ];

  checkPhase = ''
    runHook preCheck
    pushd testproject
    python manage.py test captcha
    popd
    runHook postCheck
  '';

<<<<<<< HEAD
  meta = {
    description = "Customizable Django application to add captcha images to any Django form";
    homepage = "https://github.com/mbi/django-simple-captcha";
    changelog = "https://github.com/mbi/django-simple-captcha/blob/${src.tag}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Customizable Django application to add captcha images to any Django form";
    homepage = "https://github.com/mbi/django-simple-captcha";
    changelog = "https://github.com/mbi/django-simple-captcha/blob/${src.tag}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mrmebelman
    ];
  };
}
