{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  django,
  watchfiles,

  pytestCheckHook,
  pytest-django,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-watchfiles";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-watchfiles";
    tag = finalAttrs.version;
    hash = "sha256-Yu3Y5Dx1xMO4f0616gdINezipXf2VJVbbjjOLM/unA4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    watchfiles
  ];

  pythonImportsCheck = [
    "django_watchfiles"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Make Django's autoreloader more efficient by watching for changes with watchfiles";
    homepage = "https://github.com/adamchainz/django-watchfiles";
    changelog = "https://github.com/adamchainz/django-watchfiles/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
