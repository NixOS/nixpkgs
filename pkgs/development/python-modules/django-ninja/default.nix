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
}:

buildPythonPackage rec {
  pname = "django-ninja";
  version = "1.7.1a2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    tag = "v${version}";
    hash = "sha256-Gg/j0o/UD9Zt7bHYDjpo5S5UifJplJdjOryALOCz4YU=";
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

  meta = {
    changelog = "https://github.com/vitalik/django-ninja/releases/tag/${src.tag}";
    description = "Web framework for building APIs with Django and Python type hints";
    homepage = "https://django-ninja.dev";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
