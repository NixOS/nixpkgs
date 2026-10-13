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
  version = "1.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mroboff";
    repo = "vm-curator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W0UsPEsUQfAfnQ6rkgBX1L23Fr2iPQ1Z7la9yzKl1ZA=";
  };

  cargoHash = "sha256-Z3jT9nz4ezGI36dZla+43NVTS7KP2Yzgk9McukVsLtg=";

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
