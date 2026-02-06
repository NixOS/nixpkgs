{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  poetry-core,

  # propagates
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "basedtyping";
  version = "0.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KotlinIsland";
    repo = "basedtyping";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IpIMO75jqJDzDgRPVEi6g7AprGeBeKbVH99XPDYUzTM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "basedtyping"
    "basedtyping.runtime_only"
    "basedtyping.transformer"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utilities for basedmypy";
    homepage = "https://github.com/KotlinIsland/basedtyping";
    changelog = "https://github.com/KotlinIsland/basedtyping/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
