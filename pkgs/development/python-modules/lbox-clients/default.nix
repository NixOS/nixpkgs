{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  hatchling,
  nix-update-script,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "lbox-clients";
  version = "1.1.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a3G9Jl1IfbLyI7RZY32zZTbPg8EpSZUrNy12A01Y+Qc=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/lbox-clients";

  build-system = [ hatchling ];

  dependencies = [
    google-api-core
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lbox" ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The data factory for next gen AI";
    homepage = "https://github.com/Labelbox/labelbox-python";
    changelog = "https://github.com/Labelbox/labelbox-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
