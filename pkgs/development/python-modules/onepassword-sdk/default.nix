{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "onepassword-sdk";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "1Password";
    repo = "onepassword-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mMmHC5zBY1w+Y+NAZJkP7m1CqErwCv2bMNAo1TTNm6E=";
  };

  patches = [
    # Add PEP 561 py.typed marker; remove when upstreamed in next release.
    # https://github.com/1Password/onepassword-sdk-python/issues/220
    (fetchpatch {
      url = "https://github.com/1Password/onepassword-sdk-python/commit/42c0e2e9e4af861174f70b73ef4bfa138e6a3834.patch";
      hash = "sha256-twSwe6ShQH0sWxIlzWGuz+dKr+bb4cNVvFKfPHBg2rw=";
    })
  ];

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
