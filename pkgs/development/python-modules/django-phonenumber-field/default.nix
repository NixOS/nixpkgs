{ lib
, babel
, buildPythonPackage
, django
, djangorestframework
, fetchPypi
, phonenumbers
, python
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-phonenumber-field";
  version = "7.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+c2z3ghfmcJJMoKTo7k9Tl+kQMDI47mesND1R0hil5c=";
  };

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
