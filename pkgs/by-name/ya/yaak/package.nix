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
  makeWrapper,
  nix-update-script,
  stdenv,
  lld,
  wasm-pack,
  wasm-bindgen-cli_0_2_100,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yaak";
  version = "2026.3.1";

  src = fetchFromGitHub {
    owner = "mountain-loop";
    repo = "yaak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n4hWkEIlrrSognWTdFP1EbG40oTKCNs9Ht9sn12ku48=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-9yxT7FVb13myc7r2pjUz3iweC6R01QAJCyAFlLAkRe4=";
    fetcherVersion = 2;
    makeCacheWritable = true;
    patches = [ ./fix-uuid-lockfile.patch ];
  };

  cargoHash = "sha256-MDcyEUgvj/qBVBwXcdeO5s8UFhwrc//dY62fC308Iko=";

  cargoRoot = "crates-tauri/yaak-app";

  depsExtraArgs = {
    preBuild = ''
      cp Cargo.lock ''${cargoRoot-}/Cargo.lock
    '';
  };

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
    wrapGAppsHook3
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
  # This must be set so that `npm rebuild` doesn't download wasm-pack
  env.NPM_CONFIG_IGNORE_SCRIPTS = "true";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'

    substituteInPlace crates-tauri/yaak-app/tauri.conf.json \
      --replace-fail '"0.0.0"' '"${finalAttrs.version}"'

    substituteInPlace crates-tauri/yaak-app/tauri.release.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false' \
      --replace-fail '"https://update.yaak.app/check/{{target}}/{{arch}}/{{current_version}}"' '"https://non.existent.domain"'

    substituteInPlace package.json \
      --replace-fail '"vendor:vendor-node": "node scripts/vendor-node.cjs"' '"vendor:vendor-node": ":"' \
      --replace-fail '"vendor:vendor-protoc": "node scripts/vendor-protoc.cjs"' '"vendor:vendor-protoc": ":"' \
      --replace-fail '"vendor:vendor-plugins": "node scripts/vendor-plugins.cjs"' '"vendor:vendor-plugins": ":"' \
      --replace-fail '"bootstrap:install-wasm-pack": "node scripts/install-wasm-pack.cjs"' '"bootstrap:install-wasm-pack": ":"'

    # yaakcli binary not available on aarch64-linux, replace build commands
    find plugins plugins-external packages -name 'package.json' -exec \
      sed -i 's|"yaakcli build"|":"|g; s|"yaakcli dev"|":"|g' {} +

    # Fix lockfile to match what was cached by fetchNpmDeps
    patch -p1 < ${./fix-uuid-lockfile.patch}

    # Cargo.lock is at repo root, copy to cargoRoot so cargoSetupPostPatchHook can find it
    cp Cargo.lock crates-tauri/yaak-app/Cargo.lock

    # Create vendored plugins directory structure (vendor-plugins was skipped)
    mkdir -p crates-tauri/yaak-app/vendored/plugins
    for plugin in plugins/*/; do
      name=$(basename "$plugin")
      if [ -d "plugins-external/$name" ]; then
        continue
      fi
      mkdir -p "crates-tauri/yaak-app/vendored/plugins/$name/build"
      cp "$plugin/package.json" "crates-tauri/yaak-app/vendored/plugins/$name/"
    done
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
      mkdir -p crates-tauri/yaak-app/vendored/node
      ln -s ${nodejs}/bin/node crates-tauri/yaak-app/vendored/node/yaaknode-${archPlatforms}
      mkdir -p crates-tauri/yaak-app/vendored/protoc
      ln -s ${protobuf}/bin/protoc crates-tauri/yaak-app/vendored/protoc/yaakprotoc-${archPlatforms}
      ln -s ${protobuf}/include crates-tauri/yaak-app/vendored/protoc/include
    '';

  tauriBuildFlags = [
    "--config"
    "./crates-tauri/yaak-app/tauri.release.conf.json"
  ];

  # Permission denied (os error 13)
  # write to crates-tauri/yaak-app/vendored/protoc/include
  doCheck = false;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/bin
    makeWrapper $out/Applications/Yaak.app/Contents/MacOS/yaak-app $out/bin/yaak-app
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop API client for organizing and executing REST, GraphQL, and gRPC requests";
    homepage = "https://yaak.app/";
    changelog = "https://github.com/mountain-loop/yaak/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redyf ];
    mainProgram = "yaak-app";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
