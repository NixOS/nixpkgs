{
  lib,
  rustPlatform,
  cargo-tauri,
  npmHooks,
  fetchFromGitHub,
  fetchNpmDeps,
  pkg-config,
  python3,
  nodejs,
  webkitgtk_4_1,
  glib,
  gtk3,
  openssl,
  pango,
  cairo,
  pixman,
  librsvg,
  gdk-pixbuf,
  adwaita-icon-theme,
  protobuf,
  perl,
  cacert,
  makeWrapper,
  nix-update-script,
  stdenv,
  lld,
  wasm-pack,
  wasm-bindgen-cli_0_2_121,
  autoPatchelfHook,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yaak";
  version = "2026.6.0";

  src = fetchFromGitHub {
    owner = "mountain-loop";
    repo = "yaak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uMfa1lDJ/F2uqXSQZCKAd8gQR5FwTc2bkGaci9ooldY=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-e4Ju4axd08LDDwnISMqMLXX2SuBQY0qSEdPQo1aXcCg=";
    fetcherVersion = 2;
  };

  cargoHash = "sha256-jkNW5VogUus1lS9z0SiUXnqBXWdex7aUF/89MC52Mjg=";

  cargoRoot = ".";
  buildAndTestSubdir = "crates-tauri/yaak-app-client";

  nativeBuildInputs = [
    cargo-tauri.hook
    npmHooks.npmConfigHook
    pkg-config
    nodejs
    python3
    protobuf
    perl
    makeWrapper
    lld
    wasm-pack
    wasm-bindgen-cli_0_2_121
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    gtk3
    openssl
    pango
    cairo
    pixman
    librsvg
    gdk-pixbuf
    adwaita-icon-theme
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  # Only auto-patchelf the prebuilt CLI used during the build.
  dontAutoPatchelf = true;

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'

    substituteInPlace crates-tauri/yaak-app-client/tauri.conf.json \
      --replace-fail '"0.0.0"' '"${finalAttrs.version}"'

    substituteInPlace crates-tauri/yaak-app-client/tauri.release.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"https://update.yaak.app/check/{{target}}/{{arch}}/{{current_version}}"' '"https://non.existent.domain"'

    substituteInPlace package.json \
      --replace-fail '"vendor:vendor-node": "node scripts/vendor-node.cjs",' "" \
      --replace-fail '"vendor:vendor-protoc": "node scripts/vendor-protoc.cjs",' ""
  '';

  preBuild =
    let
      npmCliPlatforms =
        {
          "aarch64-darwin" = "darwin-arm64";
          "aarch64-linux" = "linux-arm64";
          "x86_64-linux" = "linux-x64";
        }
        .${stdenv.hostPlatform.system};
    in
    ''
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        autoPatchelf node_modules/@yaakapp/cli-${npmCliPlatforms}/bin/yaak
      ''}

      mkdir -p crates-tauri/yaak-app-client/vendored/node
      ln -s ${nodejs}/bin/node crates-tauri/yaak-app-client/vendored/node/yaaknode
      mkdir -p crates-tauri/yaak-app-client/vendored/protoc
      ln -s ${protobuf}/bin/protoc crates-tauri/yaak-app-client/vendored/protoc/yaakprotoc
      ln -s ${protobuf}/include crates-tauri/yaak-app-client/vendored/protoc/include
    '';

  tauriBuildFlags = [
    "--config"
    "./tauri.release.conf.json"
  ];

  # Permission denied (os error 13)
  # write to crates-tauri/yaak-app-client/vendored/protoc/include
  doCheck = false;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/bin
    makeWrapper $out/Applications/Yaak.app/Contents/MacOS/yaak-app-client $out/bin/yaak-app-client
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop API client for organizing and executing REST, GraphQL, and gRPC requests";
    homepage = "https://yaak.app/";
    changelog = "https://github.com/mountain-loop/yaak/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redyf ];
    mainProgram = "yaak-app-client";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
