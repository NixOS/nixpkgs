{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  dj-database-url,
  django-test-migrations,
  pytest-django,
  pytest-playwright,
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

  build-system = [ hatchling ];

  dependencies = [ django ];

  nativeCheckInputs = [
    dj-database-url
    django-test-migrations
    pytest-django
    pytest-playwright
    pytestCheckHook
  ];

  disabledTestPaths = [
    # RuntimeError: Playwright failed to start. This often happens if browser drivers are missing.
    "src/polymorphic/tests/test_admin.py"
    "src/polymorphic/tests/examples/views/test.py::ViewExampleTests::test_view_example"
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
