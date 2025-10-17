{
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  lib,
  nodejs,
  npmHooks,
  pkg-config,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "venator";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "kmdreko";
    repo = "venator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qjSB/XAxB/VbO4m9Gg/XP9332WaSm/d/ejSTrHRchHg=";
  };

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-DnpqX+B0s2d5GwftPh2rpBvUuZpzG+i4+jdgcaB7fIg=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
  ];

  cargoHash = "sha256-OLtWDJuK9fXbpjUfidLP2nKdD49cWmqWI92bhV29054=";
  buildAndTestSubdir = "venator-app/src-tauri";
  npmRoot = "venator-app";

  meta = {
    description = "Desktop app for viewing logs and traces from OpenTelemetry and the Rust tracing ecosystem";
    homepage = "https://github.com/kmdreko/venator";
    license = lib.licenses.mit;
    mainProgram = "venator";
    maintainers = [ lib.maintainers.frankp ];
  };
})
