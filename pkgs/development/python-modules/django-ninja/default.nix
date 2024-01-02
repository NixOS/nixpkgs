{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, flit-core
, psycopg2
, pydantic
, pytest-asyncio
, pytest-django
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-ninja";
  version = "0.22.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    rev = "v${version}";
    hash = "sha256-oeisurp9seSn3X/5jFF9DMm9nU6uDYIU1b6/J3o2be0=";
  };

  propagatedBuildInputs = [ django pydantic ];

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    psycopg2
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/vitalik/django-ninja/releases/tag/v${version}";
    description = "Web framework for building APIs with Django and Python type hints";
    homepage = "https://django-ninja.rest-framework.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
