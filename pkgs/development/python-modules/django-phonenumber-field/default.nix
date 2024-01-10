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
  version = "7.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stefanfoulis";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QEmwCdSiaae7mhmCPcV5F01f1GRxmIur3tyhv0XK7I4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ] ++ passthru.optional-dependencies.phonenumbers;

  nativeCheckInputs = [
    babel
    djangorestframework
  ];

  pythonImportsCheck = [
    "phonenumber_field"
  ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings tests.settings
  '';

  passthru.optional-dependencies = {
    phonenumbers = [ phonenumbers ];
  };

  meta = with lib; {
    description = "A django model and form field for normalised phone numbers using python-phonenumbers";
    homepage = "https://github.com/stefanfoulis/django-phonenumber-field/";
    changelog = "https://github.com/stefanfoulis/django-phonenumber-field/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
