{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "artemis-client";
  version = "0-unstable-2026-09-11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "artemis";
    rev = "371aa6df56880643da57b30da936e9812fb0ec66";
    hash = "sha256-+zigHvrvAq8kjCMCxg+q87n0/SLC4jDP6BevuRbIx/g=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/artemis-client";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "artemis_client" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Zero-runtime-dependency Python client for a remote Artemis host";
    homepage = "https://github.com/google/artemis/tree/main/packages/artemis-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaravrav ];
  };
})
