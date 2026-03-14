{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  openssl,
  alsa-lib,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "youtui";
  version = "0.0.26";

  src = fetchFromGitHub {
    owner = "nick42d";
    repo = "youtui";
    tag = "youtui/v${finalAttrs.version}";
    hash = "sha256-OcAoaIpM6EA2ZrvPEnSzYZrRf7AakwTSEvjMm7g2xfE=";
  };

  cargoHash = "sha256-/ThEvscSrdZDNJxa+aLacg3/jnkQmevdDJngnHoGgaw=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    alsa-lib
  ];

  doCheck = false; # All tests require network access

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd youtui \
      --bash <($out/bin/youtui --generate-completions bash) \
      --fish <($out/bin/youtui --generate-completions fish) \
      --zsh <($out/bin/youtui --generate-completions zsh)
  '';

  meta = {
    description = "TUI for YouTube Music written in Rust";
    homepage = "https://github.com/nick42d/youtui";
    changelog = "https://github.com/nick42d/youtui/releases/tag/youtui%2Fv${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "youtui";
  };
})
