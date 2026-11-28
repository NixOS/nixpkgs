{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  gnupg,
  lib,
  psycopg2,
  pytestCheckHook,
  python-dotenv,
  python-gnupg,
  testfixtures,
  writableTmpDirAsHomeHook,
  hatchling,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-dbbackup";
  version = "5.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Archmonger";
    repo = "django-dbbackup";
    tag = finalAttrs.version;
    hash = "sha256-iW+KR5Q7V58FxI7qg0sytN8ZKtw/daGmdH67Lkldw3A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  pythonImportsCheck = [ "dbbackup" ];

  nativeCheckInputs = [
    gnupg
    python-gnupg
    psycopg2
    pytestCheckHook
    python-dotenv
    testfixtures
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Management commands to help backup and restore your project database and media files";
    homepage = "https://github.com/Archmonger/django-dbbackup";
    changelog = "https://github.com/Archmonger/django-dbbackup/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
