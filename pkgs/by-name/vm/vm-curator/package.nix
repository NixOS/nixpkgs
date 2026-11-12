{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vm-curator";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mroboff";
    repo = "vm-curator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yy2G8QKeqSy9BPuCK2mN9DvJhWXP2goEit+/d3ilMKM=";
  };

  cargoHash = "sha256-hTytwrh3QmDa/nZDMIggWElymJvYt75S893/buXlkfU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust TUI for managing desktop QEMU/KVM virtual machines";
    homepage = "https://github.com/mroboff/vm-curator";
    changelog = "https://github.com/mroboff/vm-curator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rachalaraj
      mroboff
    ];
    mainProgram = "vm-curator";
    platforms = lib.platforms.linux;
  };
})
