{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "twitch-tui";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = "twitch-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xPCv+69e9JIPl7K59r8PfGeuqqJcwO4ZXXHNuWMc/FA=";
  };

  cargoHash = "sha256-kUAv0+BpC3l2Z8Tos/X7bysrjoqXODBPdJ9fz6Wocx4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  __structuredAttrs = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Twitch chat in the terminal";
    homepage = "https://github.com/Xithrius/twitch-tui";
    changelog = "https://github.com/Xithrius/twitch-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lordmzte ];
    mainProgram = "twt";
  };
})
