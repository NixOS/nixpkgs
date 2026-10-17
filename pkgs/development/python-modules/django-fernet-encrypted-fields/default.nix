{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  django,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-fernet-encrypted-fields";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-fernet-encrypted-fields";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5/JT1qX9MJIvuxvg6VySuivj8gYWHIJGDDYdYrxpJ70=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    django
  ];

  pythonImportsCheck = [
    "encrypted_fields"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Symmetrically encrypted model fields for Django";
    homepage = "https://github.com/jazzband/django-fernet-encrypted-fields";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
})
