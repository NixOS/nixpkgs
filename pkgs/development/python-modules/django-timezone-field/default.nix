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
<<<<<<< HEAD
  version = "5.1";
=======
  version = "5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mfogel";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-FAYO8OEE/h4rsbC4Oc57ylWV7TqQ6DOd6/2M+mb/AsM=";
=======
    hash = "sha256-GXkvF/kAOU1JK0GDpUT1irCQlkxIWieYRqPd0fr2HXw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
