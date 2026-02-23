{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vm-curator";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "mroboff";
    repo = "vm-curator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IpG1/GhXvbpdxd6MU2DiYcnXYyVNrtHWvj8HEWk8+Lw=";
  };

  cargoHash = "sha256-SMC6qUWYp8icMNhcn+4Dll1u5Jutz8WDFsohbW6WheM=";

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
