{
  lib,
  buildPythonPackage,
  django,
  django-extensions,
  django-js-asset,
  fetchFromGitHub,
  pillow,
  python,
  pythonOlder,
  selenium,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-ckeditor";
  version = "6.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django-ckeditor";
    repo = "django-ckeditor";
    rev = "refs/tags/${version}";
    hash = "sha256-tPwWXQAKoHPpZDZ+fnEoOA29at6gUXBw6CcPdireTr8=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    django
    django-js-asset
    pillow
  ];

  DJANGO_SETTINGS_MODULE = "ckeditor_demo.settings";

  checkInputs = [
    django-extensions
    selenium
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test
    runHook postCheck
  '';

  pythonImportsCheck = [ "ckeditor" ];

  meta = with lib; {
    description = " Django admin CKEditor integration";
    homepage = "https://github.com/django-ckeditor/django-ckeditor";
    changelog = "https://github.com/django-ckeditor/django-ckeditor/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
