{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termirs";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "caelansar";
    repo = "termirs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rb8lmlWGBElj1HdPY3fCE4MnWHNQiUvqw9EdRw/OEm0=";
  };

  cargoHash = "sha256-lbYzFRXh8s5ipFoHYQS5TxZUhHliHA0zD5VLEiWXdTo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, async SSH terminal client built with Rust and Ratatui";
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
