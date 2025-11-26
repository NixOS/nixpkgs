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
  version = "0-unstable-2025-05-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = "django-cache-memoize";
    # No tags. See <https://github.com/peterbe/django-cache-memoize/issues/60>.
    rev = "e35862db483318ed751467eb576c0022015caa88";
    hash = "sha256-bXGlbU6doU28dztP4GBPFLm3frRY8FIAvguD0dyfdnU=";
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
