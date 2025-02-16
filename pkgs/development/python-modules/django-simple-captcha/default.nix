{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  django-ranged-response,
  djangorestframework,
  pillow,

  # tests
  flite,
  pytest-django,
  pytestCheckHook,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "django-simple-captcha";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-simple-captcha";
    tag = "v${version}";
    hash = "sha256-2/DDiGvQmNoC8SJabngt8RaHHo48ZDD+62Gb39aeCsg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pillow
    django-ranged-response
    djangorestframework
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
    changelog = "https://github.com/mbi/django-simple-captcha/blob/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [
      mrmebelman
      schmittlauch
    ];
  };
}
