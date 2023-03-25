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
  version = "5.0";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mfogel";
    repo = pname;
    rev = version;
    hash = "sha256-GXkvF/kAOU1JK0GDpUT1irCQlkxIWieYRqPd0fr2HXw=";
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

  nativeCheckInputs = [
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
