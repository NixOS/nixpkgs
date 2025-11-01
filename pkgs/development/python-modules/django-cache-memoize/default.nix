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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = "django-cache-memoize";
    # No tags. See <https://github.com/peterbe/django-cache-memoize/issues/60>.
    rev = "9a0dc28315b9bd2848973d38b6f63a400a0e0526";
    hash = "sha256-oORTN53s9GVHiY9tbx5FKb7ygkYUKWgPRJusdB0RfcA=";
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
