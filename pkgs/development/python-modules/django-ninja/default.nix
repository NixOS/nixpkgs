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
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    tag = "v${version}";
    hash = "sha256-nnGIhNGnK7q0nbw7EYJP+xCeS1uiuTrhQxf49dA+Sc8=";
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
