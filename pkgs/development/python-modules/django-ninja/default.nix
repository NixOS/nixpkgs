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
  version = "1.3.0-unstable-2024-11-13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    rev = "ee0f27b169fb227e8786bbf9011659f46b2795ea";
    hash = "sha256-8qjGEo2n0O4WrKqhaBZNSDAW4fTOBg/nX7T4eOoJ+Pw=";
  };

  propagatedBuildInputs = [
    django
    pydantic
  ];

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
