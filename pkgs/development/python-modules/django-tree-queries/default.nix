{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-tree-queries";
  version = "0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "feincms";
    repo = "django-tree-queries";
    tag = version;
    hash = "sha256-0RSmwgyXaLCp2GcUZ0l7zkyofd5qemd/er+7KfGsoGM=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    django
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
