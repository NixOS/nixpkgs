{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termirs";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "caelansar";
    repo = "termirs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fAl+76SmwAYiyLRRloE0MsUY9+CKtZG25ddjNAIuWjM=";
  };

  cargoHash = "sha256-Jr1RbJHjtHJAeroPwoxkUi0ytxvN7MnSwC3AhuKztXs=";

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
