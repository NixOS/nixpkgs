{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  wails,
  webkitgtk_4_0,
  pkg-config,
  libsoup_3,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tiny-rdm";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "tiny-craft";
    repo = "tiny-rdm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wSTC9Ne/Q9LLZL2+8ObMFCXrf4VSI0LkZhHHbAiXCYE=";
  };

  postPatch = ''
    substituteInPlace frontend/src/App.vue \
      --replace-fail "prefStore.autoCheckUpdate" "false"
  '';

  vendorHash = "sha256-Hh/qudoCZtIHJLsI6GQ814W4nC/uRd4gQd0PobzMlnQ=";

  env = {
    CGO_ENABLED = 1;
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/frontend";
      hash = "sha256-dcoTwfRocVjpBzqS9f2MkXjzcCI5sLjRZ3UC/Ml+7T0=";
    };
    npmRoot = "frontend";
  };

  nativeBuildInputs = [
    wails
    pkg-config
    autoPatchelfHook
    nodejs
    npmHooks.npmConfigHook
    copyDesktopItems
  ];

  buildInputs = [
    webkitgtk_4_0
    libsoup_3
  ];

  buildPhase = ''
    runHook preBuild

    wails build -m -trimpath -devtools -tags webkit2_40 -o tiny-rdm

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "tiny-rdm";
      exec = "tiny-rdm %U";
      icon = "tiny-rdm";
      type = "Application";
      terminal = false;
      desktopName = "Tiny RDM";
      startupWMClass = "tinyrdm";
      categories = [ "Office" ];
      mimeTypes = [ "x-scheme-handler/tinyrdm" ];
      comment = "Tiny Redis Desktop Manager";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 build/bin/tiny-rdm $out/bin/tiny-rdm
    install -Dm 0644 frontend/src/assets/images/icon.png $out/share/pixmaps/tiny-rdm.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, colorful, super lightweight Redis GUI client";
    homepage = "https://github.com/tiny-craft/tiny-rdm";
    mainProgram = "tiny-rdm";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ emaryn ];
    platforms = lib.platforms.linux;
  };
})
