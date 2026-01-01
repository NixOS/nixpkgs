{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage rec {
  pname = "django-treenode";
<<<<<<< HEAD
  version = "0.23.3";
=======
  version = "0.23.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "django-treenode";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-EinTO794JMUjH25WFo5LJh5HWQoOjq8hI0RR2z7u6+c=";
=======
    hash = "sha256-9AG8ntuXHB3jUHRKFDh7OOT5c0Nt8uAZnf5dR7xC/Bc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
