{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  pytest-cov-stub,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-tree-queries";
  version = "0.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "feincms";
    repo = "django-tree-queries";
    tag = version;
    hash = "sha256-GyQFVwlG7P4fxD4QYtW9mHEwwhdv4i2lgp26XVDMa3g=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    django
    pytest-cov-stub
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    pushd tests
    export DJANGO_SETTINGS_MODULE=testapp.settings
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "tree_queries"
  ];

  meta = {
    description = "Adjacency-list trees for Django using recursive common table expressions. Supports PostgreSQL, sqlite, MySQL and MariaDB";
    homepage = "https://github.com/feincms/django-tree-queries";
    changelog = "https://github.com/feincms/django-tree-queries/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
