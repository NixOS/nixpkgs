{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  wrapGAppsHook4,
  webkitgtk_4_1,
  libayatana-appindicator,
  cmake,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vrcx-0";
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = "Map1en";
    repo = "VRCX-0";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sB5DN5nAYb6sAX/v6/N3I9V2Ibcsvj841R2IAxmCr9g=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    wrapGAppsHook4
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
    libayatana-appindicator
  ];

  cargoHash = "sha256-Mo1B8nhuPtOo/rwBuaXnJerFznkAS6kOUa9MB/VxmOk=";

  buildAndTestSubdir = "src-tauri";
  # Some tests are broken currently
  doCheck = false;

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-en3BjeWiDDQVRliu0zcQxT5aZ1DQevQB19v+mcIRJFM=";
  };

  postPatch = ''
    node <<'NODE'
      const fs = require('node:fs');

      const tauriConfigPath = 'src-tauri/tauri.conf.json';
      const linuxConfigPath = 'src-tauri/tauri.linux.conf.json';

      const tauriConfig = JSON.parse(fs.readFileSync(tauriConfigPath, 'utf8'));
      let config = structuredClone(tauriConfig);

      const linuxConfig = JSON.parse(fs.readFileSync(linuxConfigPath, 'utf8'));
      config = {
          bundle: {
              ...(linuxConfig.bundle ?? {}),
              targets: ['appimage'],
              createUpdaterArtifacts: false
          }
      };

      fs.writeFileSync(linuxConfigPath, JSON.stringify(config, null, 4));
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}"
    )
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "The fast, lightweight VRCX";
    homepage = "https://github.com/Map1en/VRCX-0";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.x86_64 ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ acmdf ];
    mainProgram = "vrcx-0";
  };
})
