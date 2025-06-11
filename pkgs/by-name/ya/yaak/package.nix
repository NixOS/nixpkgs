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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yaak";
  version = "2025.1.2";

  src = fetchFromGitHub {
    owner = "mountain-loop";
    repo = "yaak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gD6gp7Qtf162zpRY0b3+g98GSH2aY07s2Auv4+lmbXQ=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-4D7ETUOLixpFB4luqQlwkGR/C6Ke6+ZmPg3dKKkrw7c=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-YxOSfSyn+gUsw0HeKrkXZg568X9CAY1UWKnGHHWCC78=";

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
  ];

  buildInputs = [
    glib
    gtk3
    openssl
    webkitgtk_4_1
    pango
    cairo
    pixman
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": "v1Compatible"' '"createUpdaterArtifacts": false'
    substituteInPlace package.json \
      --replace-fail '"bootstrap:vendor-node": "node scripts/vendor-node.cjs",' "" \
      --replace-fail '"bootstrap:vendor-protoc": "node scripts/vendor-protoc.cjs",' ""
  '';

  preBuild = ''
    mkdir -p src-tauri/vendored/node
    ln -s ${nodejs}/bin/node src-tauri/vendored/node/yaaknode-x86_64-unknown-linux-gnu
    mkdir -p src-tauri/vendored/protoc
    ln -s ${protobuf}/bin/protoc src-tauri/vendored/protoc/yaakprotoc-x86_64-unknown-linux-gnu
    ln -s ${protobuf}/include src-tauri/vendored/protoc/include
  '';

  # Permission denied (os error 13)
  # write to src-tauri/vendored/protoc/include
  doCheck = false;

  preInstall = "pushd src-tauri";

  postInstall = "popd";

  postFixup = ''
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
    platforms = [ "x86_64-linux" ];
  };
})
