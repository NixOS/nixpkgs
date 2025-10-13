{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tukai";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "hlsxx";
    repo = "tukai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YJtna4NIk9mmwymepFSZB8viUSPDU4XouRE5GCujSmk=";
  };

  cargoHash = "sha256-1V1DrewPGDJWmOoYdtK1HS/t83zFac/tgatfDTKxAmA=";

  nativeBuildInputs = [
    pkg-config
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based touch typing application";
    homepage = "https://github.com/hlsxx/tukai";
    changelog = "https://github.com/hlsxx/tukai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rein
    ];
    mainProgram = "tukai";
  };
})
