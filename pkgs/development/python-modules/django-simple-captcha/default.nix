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
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-simple-captcha";
    tag = "v${version}";
    hash = "sha256-hOvZQCAAlMYaNpAN+junhfgWej92shto7ejhKUPqbX0=";
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

  meta = with lib; {
    description = "Customizable Django application to add captcha images to any Django form";
    homepage = "https://github.com/mbi/django-simple-captcha";
    changelog = "https://github.com/mbi/django-simple-captcha/blob/${src.tag}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [
      mrmebelman
    ];
  };
}
