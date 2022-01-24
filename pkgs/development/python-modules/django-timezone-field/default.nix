{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, django
, djangorestframework
, pytz
, pytest
, pytest-lazy-fixture
, python
}:

buildPythonPackage rec {
  pname = "django-timezone-field";
  version = "4.2.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mfogel";
    repo = pname;
    rev = version;
    sha256 = "0swld4168pfhppr9q3i9r062l832cmmx792kkvlcvxfbdhk6qz9h";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    django
    djangorestframework
    pytz
  ];

  pythonImportsCheck = [
    "timezone_field"
  ];

  # Uses pytest.lazy_fixture directly which is broken in pytest-lazy-fixture
  # https://github.com/TvoroG/pytest-lazy-fixture/issues/22
  doCheck = false;

  DJANGO_SETTINGS_MODULE = "tests.settings";

  checkInputs = [
    pytest
    pytest-lazy-fixture
  ];

  checkPhase = ''
    ${python.interpreter} -m django test
  '';

  meta = with lib; {
    description = "Django app providing database, form and serializer fields for pytz timezone objects";
    homepage = "https://github.com/mfogel/django-timezone-field";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
