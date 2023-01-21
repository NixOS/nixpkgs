{ lib
, babel
, buildPythonPackage
, django
, djangorestframework
, fetchFromGitHub
, phonenumbers
, python
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-phonenumber-field";
  version = "6.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stefanfoulis";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rrJTCWn1mFV4QQu8wyLDxheHkZQ/FIE7mRC/9nXNSaM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    phonenumbers
    babel
  ];

  nativeCheckInputs = [
    djangorestframework
  ];

  pythonImportsCheck = [
    "phonenumber_field"
  ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings tests.settings
  '';

  meta = with lib; {
    description = "A django model and form field for normalised phone numbers using python-phonenumbers";
    homepage = "https://github.com/stefanfoulis/django-phonenumber-field/";
    changelog = "https://github.com/stefanfoulis/django-phonenumber-field/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
