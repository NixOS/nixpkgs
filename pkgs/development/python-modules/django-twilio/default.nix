{ lib
, buildPythonPackage
, django
, django-dynamic-fixture
, django-phonenumber-field
, fetchFromGitHub
, phonenumbers
, pytest
, pytest-django
, python
, pythonOlder
, pythonRelaxDepsHook
, twilio
}:

buildPythonPackage rec {
  pname = "django-twilio";
  version = "0.14.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rdegges";
    repo = "django-twilio";
    rev = "refs/tags/v${version}";
    hash = "sha256-I+9i1vQ4iv9TkKNkkC/1i7mc47/2GsPXP+MSj5177p8=";
  };

  nativeBuildInputs = [
    django-dynamic-fixture
    pytest
    pytest-django
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "Django"
  ];

  propagatedBuildInputs = [
    django
    django-phonenumber-field
    phonenumbers
    twilio
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m pytest
    runHook postCheck
  '';

  pythonImportsCheck = [
    "django_twilio"
  ];

  meta = with lib; {
    description = "Integrate Twilio into your Django apps with ease";
    homepage = "https://github.com/rdegges/django-twilio";
    changelog = "https://github.com/rdegges/django-twilio/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ derdennisop ];
  };
}
