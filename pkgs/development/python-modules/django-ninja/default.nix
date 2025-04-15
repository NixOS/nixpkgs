{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  flit-core,
  psycopg2,
  pydantic,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-ninja";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    tag = "v${version}";
    hash = "sha256-pMS3uL21Os9b4DlKt6jmhHM/DUAM5r3xuQ2Pu8daQvQ=";
  };

  build-system = [ flit-core ];

  dependencies = [
    django
    pydantic
  ];

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
