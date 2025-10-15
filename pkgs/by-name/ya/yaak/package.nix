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
  protobuf,
  perl,
  makeWrapper,
  nix-update-script,
  stdenv,
  lld,
  wasm-pack,
  wasm-bindgen-cli_0_2_100,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yaak";
  version = "2025.6.1";

  src = fetchFromGitHub {
    owner = "mountain-loop";
    repo = "yaak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3sEq7VpzaIMbkvHQTQLf3NRbAJjtpOJpirdcA7y2FIE=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-zz9wlJ3yQ3oTyCFrAV7vD1xENLW+vmf2Pzly4yYas/g=";
  };

  cargoHash = "sha256-CMx7vTSGeQMXpXeH4LIOKEb29CfKXQV+r8tSYdmW5U4=";

  cargoRoot = "src-tauri";

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
    wasm-bindgen-cli_0_2_100
  ];

  buildInputs = [
    glib
    gtk3
    openssl
    pango
    cairo
    pixman
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  # This must be set so that `npm rebuild` doesn't download wasm-pack
  env.NPM_CONFIG_IGNORE_SCRIPTS = "true";

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"0.0.0"' '"${finalAttrs.version}"'
    substituteInPlace src-tauri/tauri.commercial.conf.json \
      --replace-fail '"createUpdaterArtifacts": "v1Compatible"' '"createUpdaterArtifacts": false' \
      --replace-fail '"https://update.yaak.app/check/{{target}}/{{arch}}/{{current_version}}"' '"https://non.existent.domain"'
    substituteInPlace package.json \
      --replace-fail '"bootstrap:vendor-node": "node scripts/vendor-node.cjs",' "" \
      --replace-fail '"bootstrap:vendor-protoc": "node scripts/vendor-protoc.cjs",' ""
  '';

  preBuild =
    let
      archPlatforms =
        {
          "aarch64-darwin" = "aarch64-apple-darwin";
          "x86_64-darwin" = "x86_64-apple-darwin";
          "aarch64-linux" = "aarch64-unknown-linux-gnu";
          "x86_64-linux" = "x86_64-unknown-linux-gnu";
        }
        .${stdenv.hostPlatform.system};
    in
    ''
      mkdir -p src-tauri/vendored/node
      ln -s ${nodejs}/bin/node src-tauri/vendored/node/yaaknode-${archPlatforms}
      mkdir -p src-tauri/vendored/protoc
      ln -s ${protobuf}/bin/protoc src-tauri/vendored/protoc/yaakprotoc-${archPlatforms}
      ln -s ${protobuf}/include src-tauri/vendored/protoc/include
    '';

  tauriBuildFlags = [
    "--config"
    "./src-tauri/tauri.commercial.conf.json"
  ];

  # Permission denied (os error 13)
  # write to src-tauri/vendored/protoc/include
  doCheck = false;

  preInstall = "pushd src-tauri";

  postInstall = "popd";

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/yaak-app \
      --inherit-argv0 \
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop API client for organizing and executing REST, GraphQL, and gRPC requests";
    homepage = "https://yaak.app/";
    changelog = "https://github.com/mountain-loop/yaak/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redyf ];
    mainProgram = "yaak";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
