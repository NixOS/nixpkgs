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
  version = "0-unstable-2025-12-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = "django-cache-memoize";
    # No tags. See <https://github.com/peterbe/django-cache-memoize/issues/60>.
    rev = "603602f633b4137af2cb4ff8373831cbef8f27b1";
    hash = "sha256-PGPnNOjxkyhj5cxWyh3PA6jmdc2Mz3/1y7KBqE63bwU=";
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
