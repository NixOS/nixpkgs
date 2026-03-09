{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vm-curator";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "mroboff";
    repo = "vm-curator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nyq/i/MS24+5AaKs6mrsdmjO2BttqVzlLqIL6QEy1OA=";
  };

  cargoHash = "sha256-ov6Sby916opRxsEas6DCPmcI6Dkqx00lvJII/o45oEI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = {
    description = "TUI application for managing QEMU/KVM virtual machines";
    homepage = "https://github.com/mroboff/vm-curator";
    changelog = "https://github.com/mroboff/vm-curator/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mroboff ];
    mainProgram = "vm-curator";
    platforms = lib.platforms.linux;
  };
})
