{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  dj-database-url,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "4.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-polymorphic";
    repo = "django-polymorphic";
    tag = "v${version}";
    hash = "sha256-U4NOFnZOGgXStE9adixkFmf4jm6fZ2dgSmw0ainMVd0=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    dj-database-url
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "polymorphic" ];

  meta = {
    changelog = "https://github.com/jazzband/django-polymorphic/releases/tag/${src.tag}";
    homepage = "https://github.com/django-polymorphic/django-polymorphic";
    description = "Improved Django model inheritance with automatic downcasting";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
