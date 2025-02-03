{
  lib,
  asar,
  commandLineArgs ? "",
  copyDesktopItems,
  electron_30,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  zstd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ytmdesktop";
  version = "2.0.5";

  desktopItems = [
    (makeDesktopItem {
      desktopName = "YouTube Music Desktop App";
      exec = "ytmdesktop";
      icon = "ytmdesktop";
      name = "ytmdesktop";
      genericName = finalAttrs.meta.description;
      mimeTypes = [ "x-scheme-handler/ytmd" ];
      categories = [
        "AudioVideo"
        "Audio"
      ];
      startupNotify = true;
      startupWMClass = "YouTube Music Desktop App";
    })
  ];

  nativeBuildInputs = [
    asar
    copyDesktopItems
    makeWrapper
    zstd
  ];

  src = fetchurl {
    url = "https://github.com/ytmdesktop/ytmdesktop/releases/download/v${finalAttrs.version}/youtube-music-desktop-app_${finalAttrs.version}_amd64.deb";
    hash = "sha256-0j8HVmkFyTk/Jpq9dfQXFxd2jnLwzfEiqCgRHuc5g9o=";
  };

  unpackPhase = ''
    runHook preUnpack

    ar x $src data.tar.zst
    tar xf data.tar.zst

    runHook preUnpack
  '';

  postPatch = ''
    pushd usr/lib/youtube-music-desktop-app

    asar extract resources/app.asar patched-asar

    # workaround for https://github.com/electron/electron/issues/31121
    substituteInPlace patched-asar/.webpack/main/index.js \
      --replace-fail "process.resourcesPath" "'$out/lib/resources'"

    asar pack patched-asar resources/app.asar

    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,share/pixmaps}

    cp -r usr/lib/youtube-music-desktop-app/{locales,resources{,.pak}} $out/lib
    cp usr/share/pixmaps/youtube-music-desktop-app.png $out/share/pixmaps/ytmdesktop.png

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    makeWrapper ${lib.getExe electron_30} $out/bin/ytmdesktop \
      --add-flags $out/lib/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook preFixup
  '';

  meta = {
    changelog = "https://github.com/ytmdesktop/ytmdesktop/tag/v${finalAttrs.version}";
    description = "A Desktop App for YouTube Music";
    downloadPage = "https://github.com/ytmdesktop/ytmdesktop/releases";
    homepage = "https://ytmdesktop.app/";
    license = lib.licenses.gpl3Only;
    mainProgram = finalAttrs.pname;
    maintainers = [ lib.maintainers.cjshearer ];
    inherit (electron_30.meta) platforms;
    # While the files we extract from the .deb are cross-platform (javascript), the installation
    # process for darwin is different, and I don't have a test device. PRs are welcome if you can
    # add the correct installation steps. I would suggest looking at the following:
    # https://www.electronjs.org/docs/latest/tutorial/application-distribution#manual-packaging
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/instant-messengers/jitsi-meet-electron/default.nix
    badPlatforms = lib.platforms.darwin;
  };
})
