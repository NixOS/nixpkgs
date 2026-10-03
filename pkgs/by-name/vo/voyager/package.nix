{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  glib-networking,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voyager";
  version = "2.49.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aeharding";
    repo = "voyager";
    tag = finalAttrs.version;
    hash = "sha256-rQ21TknLAyv/v20908Y0SfD2bndM4AcOGh6hUvhWr18=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-taiuCg8CWJT8/9ZI+1BQUdwXZWo54mJb/fIEMqdkF+I=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-MbCYMU2XyzCKSBXjGUZ3Qnp+nH/7hKDFA4GUO05xzLM=";

  # What scripts/disable_in_app_purchases.sh does, minus the `pnpm uninstall`
  # that needs network. With the stub gone, the script skips itself.
  postPatch = ''
    rm -r src/features/tips/inAppPurchase
    mv src/features/tips/inAppPurchase__stub src/features/tips/inAppPurchase
  '';

  env = {
    BUILD_FOSS_ONLY = "true";
    APP_VERSION = finalAttrs.version;
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_11
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  # The flatpak's desktop file and icons, so they match the metainfo's app id
  postInstall = ''
    rm -r $out/share/applications $out/share/icons
    install -Dm644 -t $out/share/applications flatpak/app.vger.voyager.desktop
    install -Dm644 -t $out/share/metainfo flatpak/app.vger.voyager.metainfo.xml
    for size in 32 64 128; do
      install -Dm644 src-tauri/icons/''${size}x''${size}.png $out/share/icons/hicolor/''${size}x''${size}/apps/app.vger.voyager.png
    done
    install -Dm644 src-tauri/icons/128x128@2x.png $out/share/icons/hicolor/256x256/apps/app.vger.voyager.png
    install -Dm644 src-tauri/icons/icon.png $out/share/icons/hicolor/512x512/apps/app.vger.voyager.png
  '';

  meta = {
    description = "Mobile-first Lemmy and PieFed client";
    homepage = "https://github.com/aeharding/voyager";
    changelog = "https://github.com/aeharding/voyager/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "voyager";
    maintainers = with lib.maintainers; [ marcusramberg ];
    platforms = lib.platforms.linux;
  };
})
