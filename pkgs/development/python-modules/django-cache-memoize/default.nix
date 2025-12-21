{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "django-cache-memoize";
  version = "0-unstable-2025-12-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = "django-cache-memoize";
    # No tags. See <https://github.com/peterbe/django-cache-memoize/issues/60>.
    rev = "2112fc0507fd2d4128043d49dcccffd0b01320ca";
    hash = "sha256-4C84AFSOsO51x424hhYNS2sVg3RmRAUi/0Lqr0WkoLY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-django
  ];

  pythonImportsCheck = [ "cache_memoize" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Django utility for a memoization decorator that uses the Django cache framework";
    homepage = "https://github.com/peterbe/django-cache-memoize";
    changelog = "https://github.com/peterbe/django-cache-memoize/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    teams = [ lib.teams.ngi ];
  };
}
