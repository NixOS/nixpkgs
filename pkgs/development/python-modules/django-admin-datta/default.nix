{ lib
, buildPythonPackage
, django
, fetchPypi
, pytest
, pytest-django
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-admin-datta";
  version = "1.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Onk9T+QKsl8y68eJ2ikrUEeMc9ljzzvSw7cjjP4D3sE=";
  };

  propagatedBuildInputs = [
    django
  ];

  #tests fails without django test
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test --settings=tests.settings
    runHook postCheck
  '';

  meta = with lib; {
    description = "Modern template for Django that covers Admin Section";
    homepage = "https://appseed.us/product/datta-able/django";
    changelog = "https://github.com/app-generator/django-admin-datta/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
