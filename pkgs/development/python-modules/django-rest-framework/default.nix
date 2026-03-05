{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  importlib-metadata,
  lib,
  nix-update-script,
  pytestCheckHook,
  pytest-cov,
  pytest-django,
  pytest-flake8,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-rest-framework";
  version = "3.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    tag = version;
    hash = "sha256-kjviZFuGt/x0RSc7wwl/+SeYQ5AGuv0e7HMhAmu4IgY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    django
    pytest-cov
    pytest-flake8
    importlib-metadata
    pytestCheckHook
    pytest-django
    pytz
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Django REST framework is a powerful and flexible toolkit for building Web APIs";
    homepage = "https://github.com/encode/django-rest-framework";
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/encode/django-rest-framework/releases/tag/${src.tag}";
  };
}
