{
  lib,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  httpretty,
  mock,
  nix-update-script,
  polling,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "linode-api4";
  version = "5.46.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "linode";
    repo = "linode_api4-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d9VgHHbyEcFHy3bM2KpuwUN3Su7ABYqYRWL+nOZ1Xd4=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    deprecated
    polling
    requests
  ];

  nativeCheckInputs = [
    httpretty
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "linode_api4" ];

  disabledTestPaths = [
    # Tests require an API token
    "test/integration/"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official Python bindings for the Linode API";
    homepage = "https://github.com/linode/linode_api4-python";
    changelog = "https://github.com/linode/linode_api4-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
