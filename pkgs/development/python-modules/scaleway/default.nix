{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  poetry-core,
  pyprojectVersionPatchHook,
  scaleway-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "scaleway";
  version = "2.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-sdk-python";
    tag = finalAttrs.version;
    hash = "sha256-M4M+y3GTHMXzOlwFxbJgEX3CDiQ3xQ2mLXkSxQLThK8=";
  };

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [ scaleway-core ];

  # Tests require credentials
  doCheck = false;

  pythonImportsCheck = [ "scaleway" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Integrate Scaleway with your Python applications";
    homepage = "https://github.com/scaleway/scaleway-sdk-python";
    changelog = "https://github.com/scaleway/scaleway-sdk-python/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
