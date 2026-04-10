{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  imagemagick,
  npmHooks,
  nodejs,
  wails,
  webkitgtk_4_1,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  writeScript,
}:

buildGoModule (finalAttrs: {
  pname = "tiny-rdm";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "tiny-craft";
    repo = "tiny-rdm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t/dAhcMUT7p7MTlrEm/TRdHLRA5IvK9eeSB2+cWtCoY=";
  };

  postPatch = ''
    substituteInPlace frontend/src/App.vue \
      --replace-fail "prefStore.autoCheckUpdate" "false"
  '';

  vendorHash = "sha256-G1pnEMTxGM3YjHDtSosj5GB6Zhc9PZcbcrjGB1omQvg=";

  env = {
    CGO_ENABLED = 1;
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/frontend";
      hash = "sha256-DaRuxIRNXkafqzIJaJuttVeGXDrjjjpF2FtB1yFWPZw=";
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
    imagemagick
  ];

  buildInputs = [ webkitgtk_4_1 ];

  buildPhase = ''
    runHook preBuild

    wails build -m -trimpath -devtools -tags webkit2_41 -o tiny-rdm

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
    mkdir -p $out/share/icons/hicolor/96x96/apps
    magick frontend/src/assets/images/icon.png -resize 96x96 $out/share/icons/hicolor/96x96/apps/tiny-rdm.png

    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs.env) npmDeps;
    updateScript = writeScript "update-tiny-rdm" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p bash nix nix-update common-updater-scripts
      set -eou pipefail
      version=$(nix eval --log-format raw --raw --file default.nix tiny-rdm.version)
      nix-update tiny-rdm || true
      latestVersion=$(nix eval --log-format raw --raw --file default.nix tiny-rdm.version)
      if [[ "$latestVersion" == "$version" ]]; then
        exit 0
      fi
      update-source-version tiny-rdm "$latestVersion" --source-key=npmDeps --ignore-same-version
      nix-update tiny-rdm --version skip
    '';
  };

  meta = {
    description = "Modern, colorful, super lightweight Redis GUI client";
    homepage = "https://github.com/tiny-craft/tiny-rdm";
    mainProgram = "tiny-rdm";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
