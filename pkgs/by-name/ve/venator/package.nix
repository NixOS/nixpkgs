{
  lib,
  stdenv,
  rustPlatform,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "venator";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "kmdreko";
    repo = "venator";
    tag = "v1.0.4";
    hash = "sha256-qjSB/XAxB/VbO4m9Gg/XP9332WaSm/d/ejSTrHRchHg=";
  };

  cargoRoot = "venator-app";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-OLtWDJuK9fXbpjUfidLP2nKdD49cWmqWI92bhV29054=";

  # Nasty honestly.
  postPatch = ''
    cp ${finalAttrs.src}/venator-app/package.json .
    cp ${finalAttrs.src}/venator-app/package-lock.json .
    cp ${finalAttrs.src}/Cargo.lock venator-app/
  '';

  # Assuming our app's frontend uses `npm` as a package manager
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/venator-app";
    hash = "sha256-DnpqX+B0s2d5GwftPh2rpBvUuZpzG+i4+jdgcaB7fIg=";
  };

  cargoBuildFlags = [
    "--package"
    "venator-app"
  ];

  cargoTestFlags = [
    "--package"
    "venator-app"
  ];

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  meta = {
    description = "OpenTelemetry trace viewer GUI";
    homepage = "https://github.com/kmdreko/venator";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "venator";
  };
})
