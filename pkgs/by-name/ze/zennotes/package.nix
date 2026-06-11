# https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/sp/sparkle/package.nix used as a base

{
  lib,
  stdenv,

  fetchFromGitHub,

  nodejs,
  electron_41,
  fetchNpmDeps,
  npmHooks,

  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,

  nix-update-script,
}:
let
  pname = "zennotes";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ZenNotes";
    repo = "zennotes";
    tag = "v${version}";
    hash = "sha256-ipS/G0rcMciMQSLvhIcjlChg9BdpRKabGwuvm7ldKAc=";
  };

  npmDeps = fetchNpmDeps {
    inherit src pname version;
    hash = "sha256-9YO5YfCmAENVsfOz5jClWRtQwIS5du6wz35P3FELsWM=";
  };

  electron = electron_41;
in
stdenv.mkDerivation (finalAttrs: {
  inherit
    src
    pname
    version
    npmDeps
    ;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    makeWrapper
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    runHook preBuild
    pushd apps/desktop

    npm exec electron-vite -- build
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/zennotes
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/lib/zennotes/

    install -D apps/desktop/build/icon.png $out/share/icons/hicolor/512x512/apps/zennotes.png

    # electron app
    makeWrapper '${lib.getExe electron}' $out/bin/zennotes \
      --add-flags $out/lib/zennotes/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    # cli tool
    makeWrapper '${lib.getExe nodejs}' $out/bin/zen \
      --add-flags $out/lib/zennotes/resources/cli.js

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zennotes";
      desktopName = "ZenNotes";
      exec = "zennotes %U";
      terminal = false;

      type = "Application";
      icon = "zennotes";
      startupWMClass = "ZenNotes";
      comment = "ZenNotes desktop shell";

      categories = [ "Office" ];
      mimeTypes = [
        "text/markdown"
        "x-scheme-handler/zennotes"
      ];

    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Keyboard-based Markdown notes app";
    homepage = "https://zennotes.org/";
    license = lib.licenses.mit;
    mainProgram = "zennotes";
    changelog = "https://github.com/ZenNotes/zennotes/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ ad030 ];
    platforms = lib.platforms.linux;
  };
})
