{ lib
, fetchFromGitHub
, buildPythonPackage
, python
, babel
, django
, djangorestframework
, phonenumbers
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-phonenumber-field";
  version = "6.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "stefanfoulis";
    repo = pname;
    rev = version;
    sha256 = "sha256-rrJTCWn1mFV4QQu8wyLDxheHkZQ/FIE7mRC/9nXNSaM=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ django phonenumbers babel ];

  checkInputs = [ djangorestframework ];

  pythonImportsCheck = [ "phonenumber_field" ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkPhase = ''
    ${python.interpreter} -m django test --settings tests.settings
  '';

  meta = with lib; {
    description = "A django model and form field for normalised phone numbers using python-phonenumbers";
    homepage = "https://github.com/stefanfoulis/django-phonenumber-field/";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
