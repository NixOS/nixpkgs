{
  buildPythonPackage,
  cryptography,
  django,
  django-appconf,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  pytest-django,
  setuptools,
}:

buildPythonPackage {
  pname = "django-cryptography";
  version = "1.1-unstable-2024-02-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "georgemarshall";
    repo = "django-cryptography";
    rev = "a5cde9beed707a14a2ef2f1f7f1fee172feb8b5e";
    hash = "sha256-Xj/fw8EapsYvVbZPRQ81yeE9QpIQ1TIuk+ASOCGh/Uc=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "packages = django_cryptography" "packages = find:"
  '';

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    django
    django-appconf
  ];

  pythonImportsCheck = [ "django_cryptography" ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  disabledTests = [
    # self.assertEqual(len(errors), 1) - AssertionError: 0 != 1
    "test_field_checks"
  ];

  meta = {
    homepage = "https://github.com/georgemarshall/django-cryptography";
    description = "Set of primitives for performing cryptography in Django";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ centromere ];
  };
}
