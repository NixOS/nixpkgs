{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  nix-update-script,
  typing-extensions,
  pyright,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nexus-rpc";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexus-rpc";
    repo = "sdk-python";
    tag = finalAttrs.version;
    hash = "sha256-il+zCyU0dOlqFHGedyeBKgwQlqx1FLNuriGIw3RV3Gs=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Patch out uv and run tests directly
    substituteInPlace tests/test_type_errors.py \
      --replace-fail '["uv", "run", "pyright",' '["pyright",'
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pyright
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nexusrpc"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nexus Python SDK";
    homepage = "https://temporal.io/";
    changelog = "https://github.com/nexus-rpc/sdk-python/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jpds
    ];
  };
})
