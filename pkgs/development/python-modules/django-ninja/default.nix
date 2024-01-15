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
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    rev = "v${version}";
    hash = "sha256-hF6Z8i8M4mQtVPIupTSEIkJh0i/oMFFuE9PpODxq4fw=";
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
    homepage = "https://django-ninja.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
