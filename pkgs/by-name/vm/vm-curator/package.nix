{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "vm-curator";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "mroboff";
    repo = "vm-curator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PIpAagUuwduyEUHncjazYFyNqGa1hkZvO+KXJkaKNMM=";
  };

  cargoHash = "sha256-gk5iFT8lV9/uB3s0/s1//q6G/cPFALXGuaSJpTkigwQ=";

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
