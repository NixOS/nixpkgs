{
  lib,
  stdenv,

  fetchFromGitHub,
  makeDesktopItem,

  copyDesktopItems,
  makeWrapper,
  nodejs,
  yarn-berry_4,
  zip,

  electron,
  commandLineArgs ? "",

  nix-update-script,
}:

let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ytmdesktop";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "ytmdesktop";
    repo = "ytmdesktop";
    tag = "v${finalAttrs.version}";
    leaveDotGit = true;

    postFetch = ''
      cd $out
      git rev-parse HEAD > .COMMIT
      find -name .git -print0 | xargs -0 rm -rf
    '';

    hash = "sha256-CA3Vb7Wp4WrsWSVtIwDxnEt1pWYb73WnhyoMVKoqvOE=";
  };

  patches = [
    # instead of running git during the build process
    # use the .COMMIT file generated in the fetcher FOD
    ./git-rev-parse.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace viteconfig/main.ts

    # workaround for https://github.com/electron/electron/issues/31121
    substituteInPlace src/main/index.ts \
      --replace-fail "process.resourcesPath" "'$out/share/ytmdesktop/resources'"
  '';

  missingHashes = ./missing-hashes.json;

  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-1jlnVY4KWm+w3emMkCkdwUtkqRB9ZymPPGuvgfQolrA=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
    zip
  ];

  # Don't auto-run scripts of dependencies
  # We don't need any native modules, so this is fine
  env.YARN_ENABLE_SCRIPTS = "0";

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

    yarn run package

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
      --add-flags ${lib.escapeShellArg commandLineArgs}
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
