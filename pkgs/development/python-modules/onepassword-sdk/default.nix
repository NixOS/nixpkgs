{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "onepassword-sdk";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "1Password";
    repo = "onepassword-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vel1KQEc8yISn1uYSjjH7lnkOj9gmEbqCRmWY759DRE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pydantic
  ];

  # Tests require a live 1Password service account token.
  doCheck = false;

  pythonImportsCheck = [ "onepassword" ];

  meta = {
    description = "1Password Python SDK for programmatic secret management";
    homepage = "https://github.com/1Password/onepassword-sdk-python";
    changelog = "https://github.com/1Password/onepassword-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
  };
})
