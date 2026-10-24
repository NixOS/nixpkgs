{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri_1,
  npmHooks,
  pkg-config,
  wrapGAppsHook4,
  glib-networking,
  webkitgtk_4_1,
  libsoup_2_4,
  libappindicator-gtk3,
  librsvg,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  prefetch-npm-deps,
  python3,
  nodejs,
  cairo,
  pango,
  libjpeg,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "window-pet";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "SeakMengs";
    repo = "WindowPet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NflJpMGcAAoIjXO/MXeJnBWjwO52TjEfkkS6RUQYFxY=";
  };

  patches = [
    # npm update nan
    ./bump-deps.patch
  ];

  cargoRoot = "src-tauri";
  cargoHash = "sha256-P0ZzLIGBj05RlPSKfSDYE47n4HlTpVWtitm478ynhdg=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = finalAttrs.src;
    patches = [ ./bump-deps.patch ];
    hash = "sha256-p5q1zeVa2nA00LlKYuIN2OUekjAOTqpOhh/ShxnjihQ=";
    forceGitDeps = true;
  };
  makeCacheWritable = true;
  forceGitDeps = true;

  nativeBuildInputs = [
    cargo-tauri_1.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    copyDesktopItems
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libsoup_2_4
    libappindicator-gtk3
    librsvg
    cairo
    pango
    libjpeg
    openssl
  ];

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "WindowPet";
      exec = "window-pet";
      icon = "window-pet";
      categories = [ "Office" ];
      comment = finalAttrs.meta.description;
    })
  ];

  postInstall = ''
    mkdir -p $out/share/licenses/window-pet
    install -Dm644 LICENSE.md $out/share/licenses/window-pet/LICENSE

    mkdir -p $out/share/icons/hicolor/{128x128,256x256@2,32x32}/apps
    install -Dm644 src-tauri/icons/128x128.png $out/share/icons/hicolor/128x128/apps/window-pet.png
    install -Dm644 src-tauri/icons/128x128@2x.png $out/share/icons/hicolor/256x256@2/apps/window-pet.png
    install -Dm644 src-tauri/icons/32x32.png $out/share/icons/hicolor/32x32/apps/window-pet.png
    mkdir -p $out/share/pixmaps
    install -Dm644 src-tauri/icons/icon.png $out/share/pixmaps/window-pet.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pet overlay app that lets you have adorable companion such as pets, anime characters on your screen";
    homepage = "https://github.com/SeakMengs/WindowPet";
    changelog = "https://github.com/SeakMengs/WindowPet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
    mainProgram = "window-pet";
  };
})
