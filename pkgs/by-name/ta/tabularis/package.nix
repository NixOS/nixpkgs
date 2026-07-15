{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo-tauri,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  wrapGAppsHook4,
  webkitgtk_4_1,
  pkg-config,
  openssl,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tabularis";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "debba";
    repo = "tabularis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kObjJ+C+0d/wLNt902yUPe8Cvss8d0ILeuo98vIiYDU=";
  };

  patches = [
    ./disable-updater.patch
  ];

  strictDeps = true;

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-XYvwgZMJXM62kC8+DR06LygtTnL+8TLWyRZAgTQWf3Q=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-S/XCypKyYlJtuISNiG8NtJzisAejiUwqPVltXEmVlZw=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pnpmConfigHook
    pnpm

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  env.OPENSSL_NO_VENDOR = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, developer-focused database management tool, built with Tauri and React";
    homepage = "http://tabularis.dev";
    changelog = "https://github.com/debba/tabularis/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "tabularis";
  };
})
