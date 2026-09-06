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
  version = "0-unstable-2026-03-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = "django-cache-memoize";
    # No tags. See <https://github.com/peterbe/django-cache-memoize/issues/60>.
    rev = "4f4c5e323abb7975a10b70f38a619db4a74d5823";
    hash = "sha256-DqW9P1Su/KVrDvEicHpHg7/L6Wqg1ShEVkYSSNm9Kp0=";
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
