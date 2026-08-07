{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools-scm,
  lib,
  django,
  pytestCheckHook,
  pytest-django,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-user-sessions";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-user-sessions";
    tag = finalAttrs.version;
    hash = "sha256-vHLeEmlVil1iJi+YkxL5c04Vq/b5b43tjC2ZcjH4/Ys=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    django
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  disabledTestPaths = [
    # AssertionError: UserWarning not triggered
    "tests/test_admin.py::AdminTest::test_expired"
    "tests/test_admin.py::AdminTest::test_list"
    "tests/test_admin.py::AdminTest::test_mine"
    "tests/test_admin.py::AdminTest::test_search"
    "tests/test_admin.py::AdminTest::test_unexpired"
    "tests/test_template_filters.py::LocationTemplateFilterTest::test_no_location"
    "tests/test_views.py::ViewsTest::test_delete_all_other"
    "tests/test_views.py::ViewsTest::test_delete_some_other"
    "tests/test_views.py::ViewsTest::test_list"
  ];

  meta = {
    description = "Extend Django sessions with a foreign key back to the user, allowing enumerating all user's sessions";
    homepage = "https://github.com/jazzband/django-user-sessions";
    changelog = "https://github.com/jazzband/django-user-sessions/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
