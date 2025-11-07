{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termirs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "caelansar";
    repo = "termirs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yQ9WmvnIJJHhhXNTHZeHGz2uYVAxuFPf2U1WzybjJqU=";
  };

  cargoHash = "sha256-J/TgFi0iyhaj9/aF3Gd46PNq/QE+hQfF2YawbJf/5AA=";

  passthru.updateScript = nix-update-script { };

  # Try to access network stack in sandboxed darwin
  checkFlags = lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    "--skip=async_ssh_client::tests::test_connect_embedded_server"
    "--skip=async_ssh_client::tests::test_port_forwarding"
    "--skip=async_ssh_client::tests::test_port_forwarding_recovers_after_session_drop"
    "--skip=async_ssh_client::tests::test_sftp_receive_large_file"
    "--skip=async_ssh_client::tests::test_sftp_send_large_file"
    "--skip=async_ssh_client::tests::test_sftp_send_receive_roundtrip"
  ];

  meta = {
    description = "Modern async SSH terminal client built with Rust and Ratatui";
    longDescription = ''
      TermiRs provides a fast, secure, and user-friendly terminal
      interface for managing SSH connections with advanced features
      like secure file transfers and encrypted configuration storage.
    '';
    homepage = "https://github.com/caelansar/termirs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "termirs";
  };
})
