{
  lib,
  stdenv,

  fetchFromGitHub,
  makeDesktopItem,

  copyDesktopItems,
  fetchPnpmDeps,
  makeWrapper,
  nodejs,
  pnpm_12,
  pnpmConfigHook,
  zip,

  electron,
  commandLineArgs ? "",

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ytmdesktop";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ytmdesktop";
    repo = "ytmdesktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fXwjU8aSi4L83z7yakmLQzDymIjYDsjot2B3AWd69yo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-PEb/i5OwGF224XxZ+pQMAvarRP0LsytCUOXYjBBmm7c=";
  };

  postPatch = ''
    # On Linux the app.asar is run with the nixpkgs Electron binary, so
    # process.resourcesPath points at Electron's resources instead of the app's.
    # app.getAppPath() is the app.asar in both cases; use its parent directory.
    substituteInPlace \
      src/main/index.ts \
      src/main/util.ts \
      src/main/services/protocolmanager/index.ts \
      --replace-fail "process.resourcesPath" "path.dirname(app.getAppPath())"
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    nodejs
    pnpm_12
    pnpmConfigHook
    zip
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    # force @electron/packager to use our electron instead of downloading it
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail 'await this.getElectronZipPath(downloadOpts)' '"electron.zip"'

    # electron-forge's console output is squeezed into one narrow column if unset
    export CI="1";

    pnpm run package

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''

    mkdir -p "$out"/share/ytmdesktop
    cp -r out/*/{locales,resources{,.pak}} "$out"/share/ytmdesktop

    install -Dm644 src/assets/icons/ytmd.png "$out"/share/pixmaps/ytmdesktop.png

    makeWrapper ${lib.getExe electron} "$out"/bin/ytmdesktop \
      --add-flags "$out"/share/ytmdesktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs} \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r out/*/"YouTube Music Desktop App".app "$out"/Applications

    wrapProgram "$out"/Applications/"YouTube Music Desktop App".app/Contents/MacOS/youtube-music-desktop-app \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    makeWrapper "$out"/Applications/"YouTube Music Desktop App".app/Contents/MacOS/youtube-music-desktop-app "$out"/bin/ytmdesktop
  ''
  + ''
    runHook postInstall
  '';

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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ytmdesktop/ytmdesktop/releases/tag/v${finalAttrs.version}";
    description = "Desktop App for YouTube Music";
    downloadPage = "https://github.com/ytmdesktop/ytmdesktop/releases";
    homepage = "https://ytmdesktop.app/";
    license = lib.licenses.gpl3Only;
    mainProgram = "ytmdesktop";
    maintainers = [ lib.maintainers.cjshearer ];
    inherit (electron.meta) platforms;
  };
})
