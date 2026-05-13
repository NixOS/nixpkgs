{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  wrapGAppsHook4,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  pkg-config,
  nix-update-script,

  glib-networking,
  webkitgtk_4_1,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terax";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "crynta";
    repo = "terax-ai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sjwh5XoTK19EcYjkVmOc4rMJdWNJKdQFXGZjLH3MW5A=";
  };

  cargoHash = "sha256-4yY9JvH7+E9ilMSK88MvfB1mVH90C0WddSIpKfwq5A0=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  pnpmDeps = fetchPnpmDeps {
    fetcherVersion = 3;
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    hash = "sha256-LydUQvlS1zYpnhwX3B2EfZjPHfpA5l9Lh9pqMfQeTvQ=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpmConfigHook
    pnpm_9
    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
  ];

  # Disable updater artifacts in the nix build since we don't have the signing key.
  # Write the config to src-tauri/ so it's accessible after pushd into buildAndTestSubdir.
  tauriConf = builtins.toJSON { bundle.createUpdaterArtifacts = false; };
  preBuild = ''
    tauriConfPath="$PWD/src-tauri/tauriConf.json"
    printf "%s" "$tauriConf" > "$tauriConfPath"
    tauriBuildFlags+=(
      "--config"
      "tauriConf.json"
    )
  '';

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script { };
  };

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  __structuredAttrs = true;

  meta = {
    description = "AI-native terminal emulator with multi-tab, file explorer, code editor, web preview, voice input, and AI agents";
    longDescription = ''
      Terax is an open-source terminal emulator that integrates AI capabilities
      directly into the terminal experience. It features multiple tabs,
      a file explorer, built-in code editor, web preview, voice input, and
      first-class AI agent support through multiple providers.
    '';
    homepage = "https://github.com/crynta/terax-ai";
    changelog = "https://github.com/crynta/terax-ai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vomba ];
    mainProgram = "terax";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
