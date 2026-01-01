{
  buildPythonPackage,
  cryptography,
  django,
  django-appconf,
  fetchFromGitHub,
  lib,
<<<<<<< HEAD
  pytestCheckHook,
  pytest-django,
  setuptools,
}:

buildPythonPackage {
  pname = "django-cryptography";
  version = "1.1-unstable-2024-02-16";
  pyproject = true;
=======
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-cryptography";
  version = "1.1";
  disabled = pythonOlder "3.7";
  format = "pyproject";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "georgemarshall";
    repo = "django-cryptography";
<<<<<<< HEAD
    rev = "a5cde9beed707a14a2ef2f1f7f1fee172feb8b5e";
    hash = "sha256-Xj/fw8EapsYvVbZPRQ81yeE9QpIQ1TIuk+ASOCGh/Uc=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "packages = django_cryptography" "packages = find:"
  '';

  build-system = [ setuptools ];

  dependencies = [
=======
    tag = version;
    hash = "sha256-C3E2iT9JdLvF+1g+xhZ8dPDjjh25JUxLAtTMnalIxPk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cryptography
    django
    django-appconf
  ];

<<<<<<< HEAD
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
=======
  patches = [
    # See: https://github.com/georgemarshall/django-cryptography/pull/88
    ./fix-setup-cfg.patch
  ];

  pythonImportsCheck = [ "django_cryptography" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} ./runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/georgemarshall/django-cryptography";
    description = "Set of primitives for performing cryptography in Django";
    license = licenses.bsd3;
    maintainers = with maintainers; [ centromere ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
