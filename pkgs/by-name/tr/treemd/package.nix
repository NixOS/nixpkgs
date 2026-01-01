{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "treemd";
<<<<<<< HEAD
  version = "0.5.4";
=======
  version = "0.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Epistates";
    repo = "treemd";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-EIAKppVPPSQWH+2jX/z4Wdc9qm09THEnD3J1erva1lY=";
  };

  cargoHash = "sha256-OtHwKp3uTYDZMyl0/hNw83VwGMIh2WrWkU+nC8JShAw=";
=======
    hash = "sha256-7pgRQ5e1rMufEWXFLD+z1YYGjLX5fSw4ArLwjKUkJ+4=";
  };

  cargoHash = "sha256-OEZR+uS/ga3e2fcu4ZiaZ6ATwCFIosDUU1FVD/gu1WY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI/CLI markdown navigator with tree-based structural navigation";
    homepage = "https://github.com/Epistates/treemd";
    changelog = "https://github.com/Epistates/treemd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "treemd";
  };
})
