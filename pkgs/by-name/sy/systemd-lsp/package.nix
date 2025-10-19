{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "2025.07.14";

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JjrPgpQ94C01nZ3E1NE88TBzI03YFs+x37edtYStlnc=";
  };

  cargoHash = "sha256-G1cQWOgtx+Bmi05ji9Z4TBj5pnhglNcfLRoq2zSmyK0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server implementation for systemd unit files made in Rust";
    homepage = "https://github.com/JFryy/systemd-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
  };
})
