{
  lib,
  stdenv,

  binaryen,
  buildWasmBindgenCli,
  cargo,
  cargo-tauri,
  cmake,
  curl,
  fetchCrate,
  fetchFromGitHub,
  glib-networking,
  lld,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  rustPlatform,
  wasm-pack,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  wasmBindgenSrc = fetchCrate {
    pname = "wasm-bindgen-cli";
    version = "0.2.130";
    hash = "sha256-9Og1O/6/VC3sc5hBjoIWBErmLW2UHGMsTQO+6+m/dng=";
  };

  wasm-bindgen-cli = buildWasmBindgenCli {
    src = wasmBindgenSrc;
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (wasmBindgenSrc) pname version;
      src = wasmBindgenSrc;
      hash = "sha256-j81sUf1m5yXU4FJfGj7GV+hdqVCV8mRmNb0QIsMCjqw=";
    };
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typbase";
  version = "0.5.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lemueldls";
    repo = "typbase";
    tag = "typbase-v${finalAttrs.version}";
    hash = "sha256-p+wkG0htJTGPjq3swr2f0IqTvCLWpVpHst8ucrv4gzM=";
  };

  cargoHash = "sha256-N7r9OmLjTsvmtjwsb/TC5PozWHn94NLnXEtGICuUzNc=";

  buildAndTestSubdir = "apps/native";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-aVLWvPfl+VSV07XYyfYzDnW8AGf9DMTUnzBD5w6oSoM=";
    nativeBuildInputs = [ cargo ];
  };

  nativeBuildInputs = [
    binaryen
    cargo-tauri.hook
    cmake
    lld
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm
    wasm-bindgen-cli
    wasm-pack
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin curl
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
  ];

  tauriBuildFlags = [
    "--config"
    "tauri.package.conf.json"
    "--config"
    ''{"build":{"beforeBuildCommand":"true"}}''
  ];

  preBuild = ''
    (cd packages/engine && printf '{}' > pkg/package.json \
      && wasm-pack build --mode no-install --release --target web --scope typbase --no-opt .)
    wasm-opt -O4 \
      --enable-bulk-memory \
      --enable-bulk-memory-opt \
      --enable-call-indirect-overlong \
      --enable-multivalue \
      --enable-mutable-globals \
      --enable-nontrapping-float-to-int \
      --enable-reference-types \
      --enable-sign-ext \
      packages/engine/pkg/engine_bg.wasm \
      -o packages/engine/pkg/engine_bg.opt.wasm
    mv packages/engine/pkg/engine_bg.opt.wasm packages/engine/pkg/engine_bg.wasm

    pnpm --filter @typbase/web generate
  '';

  env = {
    COREPACK_ENABLE_STRICT = 0;

    OPENSSL_NO_VENDOR = true;

    NUXT_TELEMETRY_DISABLED = 1;
    NUXT_PUBLIC_APP_URL = "https://typbase.at";
    NUXT_PUBLIC_PROXY_URL = "https://proxy.typbase.at";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "typbase-v(.*)"
    ];
  };

  meta = {
    description = "Local-first knowledge base made for Typst and the Atmosphere.";
    homepage = "https://github.com/lemueldls/typbase";
    changelog = "https://github.com/lemueldls/typbase/releases/tag/typbase-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "typbase";
    maintainers = [ lib.maintainers.lemueldls ];
    platforms = lib.platforms.linux;
  };
})
