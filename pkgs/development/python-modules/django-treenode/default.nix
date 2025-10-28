{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage rec {
  pname = "django-treenode";
  version = "0.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "django-treenode";
    tag = version;
    hash = "sha256-9AG8ntuXHB3jUHRKFDh7OOT5c0Nt8uAZnf5dR7xC/Bc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  pythonImportsCheck = [
    "treenode"
  ];

  meta = {
    description = "Deciduous_tree: probably the best abstract model/admin for your tree based stuff";
    homepage = "https://github.com/fabiocaccamo/django-treenode";
    changelog = "https://github.com/fabiocaccamo/django-treenode/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leona ];
  };
}
