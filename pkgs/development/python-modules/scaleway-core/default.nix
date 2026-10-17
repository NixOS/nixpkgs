{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  poetry-core,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "scaleway-core";
  version = "2.12.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-sdk-python";
    tag = finalAttrs.version;
    hash = "sha256-JvlCCy0RrOUGuwWcWqQdvRfCVtooNvkjpIBxb6NPOSY=";
  };

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    python-dateutil
    pyyaml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scaleway_core" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Integrate Scaleway with your Python applications";
    homepage = "https://github.com/scaleway/scaleway-sdk-python";
    changelog = "https://github.com/scaleway/scaleway-sdk-python/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
