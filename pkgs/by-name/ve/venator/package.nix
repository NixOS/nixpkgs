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

  nix-update-script,
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

  cargoRoot = "venator-app";
  buildAndTestSubdir = "venator-app";
  # NOTE: don't put npmRoot here because it will break the build with "Found
  # version mismatched Tauri packages".
  #
  # Nasty workaround to `npmRoot` not working. I don't know man...
  postPatch = ''
    cp ${finalAttrs.src}/venator-app/package.json .
    cp ${finalAttrs.src}/venator-app/package-lock.json .
    cp ${finalAttrs.src}/Cargo.lock venator-app/
  '';

  cargoHash = "sha256-OLtWDJuK9fXbpjUfidLP2nKdD49cWmqWI92bhV29054=";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/venator-app";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop app for viewing logs and traces from OpenTelemetry and the Rust tracing ecosystem";
    homepage = "https://github.com/kmdreko/venator";
    license = lib.licenses.mit;
    mainProgram = "venator";
    maintainers = [
      lib.maintainers.frankp
      lib.maintainers._9999years
    ];
  };
})
