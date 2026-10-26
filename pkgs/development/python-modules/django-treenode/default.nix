{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-treenode";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "django-treenode";
    tag = finalAttrs.version;
    hash = "sha256-MsMNKptwxBNHgW+0juIkJCD8qdXvXzorwL/DnL+FqgQ=";
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
    changelog = "https://github.com/fabiocaccamo/django-treenode/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leona ];
  };
})
