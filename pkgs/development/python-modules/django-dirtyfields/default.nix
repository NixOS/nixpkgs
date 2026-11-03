{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  pytest-django,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-dirtyfields";
  version = "1.9.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "romgar";
    repo = "django-dirtyfields";
    tag = finalAttrs.version;
    hash = "sha256-+UX/SKzZ/B2oJ+HHGUgh6DNxeQZMGHQm+zJ5bsSpf38=";
  };

  build-system = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 80.9.0, < 81" "setuptools"

    substituteInPlace tests/models.py \
      --replace-fail "from jsonfield import JSONField as JSONFieldThirdParty" "from django.db.models import JSONField as JSONFieldThirdParty"
  '';

  dependencies = [
    django
  ];

  pythonImportsCheck = [
    "dirtyfields"
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tracking dirty fields on a Django model";
    homepage = "https://github.com/romgar/django-dirtyfields";
    changelog = "https://github.com/romgar/django-dirtyfields/blob/${finalAttrs.src.rev}/ChangeLog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
