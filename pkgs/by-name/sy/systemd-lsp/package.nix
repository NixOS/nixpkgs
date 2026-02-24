{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "2025.10.16";

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xhk1jUAA81Rkq9Nmcw+XyWrSbq3ygRvS615Z56j0WBM=";
  };

  cargoHash = "sha256-6hePUny2iBjslkIk8wVXHnuAHzG3WpBdcj8D5FM9Bc4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server implementation for systemd unit files made in Rust";
    homepage = "https://github.com/JFryy/systemd-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
  };
})
