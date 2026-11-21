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
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-simple-captcha";
    tag = "v${version}";
    hash = "sha256-DROjHdUY6f3KYaMTK0+6xhjPt6MmR6WSFdxtVsX0xN0=";
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

  meta = {
    description = "Customizable Django application to add captcha images to any Django form";
    homepage = "https://github.com/mbi/django-simple-captcha";
    changelog = "https://github.com/mbi/django-simple-captcha/blob/${src.tag}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrmebelman
    ];
  };
}
