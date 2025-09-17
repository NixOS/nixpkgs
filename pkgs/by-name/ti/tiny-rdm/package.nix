{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
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
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "tiny-craft";
    repo = "tiny-rdm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LzZsnO14cyYzmEas23Mrf0I+ZZa7y4ZfLg/gPBLcNc8=";
  };

  postPatch = ''
    substituteInPlace frontend/src/App.vue \
      --replace-fail "prefStore.autoCheckUpdate" "false"
  '';

  vendorHash = "sha256-dv+1yRl0UUo6lkLjfYAgRDR8pMfuh4lM6JapIXNQG9Q=";

  env = {
    CGO_ENABLED = 1;
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/frontend";
      hash = "sha256-0QMakUr2QBDYb/BRMALOACsfknrzimgaNkdFMjg73og=";
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
    install -Dm 0644 frontend/src/assets/images/icon.png $out/share/pixmaps/tiny-rdm.png

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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
