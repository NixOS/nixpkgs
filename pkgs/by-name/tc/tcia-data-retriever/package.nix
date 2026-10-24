{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  wails,
  webkitgtk_4_1,
  glib-networking,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  wrapGAppsHook3,
}:

buildGoModule (finalAttrs: {
  pname = "tcia-data-retriever";
  version = "0.16.0-20260529";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TCIA";
    repo = "data-retriever";
    tag = finalAttrs.version;
    hash = "sha256-TLuhs0rHjPlbd/8TfUCYBNVhGudcwviuGOei6aPNn6U=";
  };

  # The Angular production build inlines Google Fonts by fetching them over the
  # network, which fails in the sandbox. Disable font inlining (the fonts are
  # already vendored under frontend/src/assets).
  postPatch = ''
    substituteInPlace frontend/angular.json \
      --replace-fail '"outputHashing": "all"' '"outputHashing": "all",
              "optimization": { "fonts": false }'
  '';

  vendorHash = "sha256-dGlDC8VxO8+q+h9WcBBSJTzl3vjNxVnsqaS3PY49SdI=";

  env = {
    CGO_ENABLED = 1;
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/frontend";
      hash = "sha256-b4O4Qf7DHM/dG177yVeduBUNEk2hWkqfel9Aliry/dc=";
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
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
  ];

  buildPhase = ''
    runHook preBuild

    wails build -m -trimpath -tags webkit2_41 -o tcia-data-retriever

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "tcia-data-retriever";
      exec = "tcia-data-retriever %U";
      icon = "tcia-data-retriever";
      desktopName = "TCIA Data Retriever";
      genericName = "Cancer Imaging Archive downloader";
      comment = "Download medical imaging data from The Cancer Imaging Archive";
      categories = [
        "Network"
        "Science"
      ];
      startupWMClass = "TCIA_Data_Retriever";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 build/bin/tcia-data-retriever $out/bin/tcia-data-retriever
    install -Dm0644 frontend/src/assets/AppIcon.iconset/icon_512x512.png \
      $out/share/icons/hicolor/512x512/apps/tcia-data-retriever.png

    runHook postInstall
  '';

  meta = {
    description = "Desktop GUI and CLI for downloading data from The Cancer Imaging Archive";
    homepage = "https://github.com/TCIA/data-retriever";
    license = lib.licenses.asl20;
    mainProgram = "tcia-data-retriever";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
