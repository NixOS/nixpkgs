{
  lib,
  stdenv,
  fetchFromGitHub,

  copyDesktopItems,
  fetchYarnDeps,
  makeDesktopItem,
  writableTmpDirAsHomeHook,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,

  libsecret,
  xorg,

  electron_37,
  jdk,
  nodejs,

  cacert,
  node-gyp,
  pkg-config,
  python3,
  ripgrep,
}:
let
  electron = electron_37;

  version = "1.64.100";

  src = fetchFromGitHub {
    owner = "eclipse-theia";
    repo = "theia-ide";
    tag = "v${version}";
    hash = "sha256-kt+J4j48XsPcZa7nUhK2mKaViBx9356gb28G9fYGWxE=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-BU2iM1y2IBEBxs82SeGx7h9VYifxFczP/68aWrxWr/A=";
  };

  theiaPlugins = stdenv.mkDerivation {
    pname = "theia-plugins";
    inherit version src yarnOfflineCache;

    nativeBuildInputs = [
      cacert
      nodejs
      writableTmpDirAsHomeHook
      yarnConfigHook
    ];

    installPhase = ''
      runHook preInstall

      yarn download:plugins
      mkdir -p $out
      cp -vr plugins $out

      runHook postInstall
    '';

    dontPatchShebangs = true;

    outputHash = "sha256-14+V7DREcDuLJl+Z/a2BUE8jNdIPvFgNLgq5/Pz7Rzw=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in

stdenv.mkDerivation {
  pname = "theia-ide";
  inherit version src yarnOfflineCache;

  buildInputs = [
    xorg.libX11
    xorg.libxkbfile
    libsecret
  ];

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    copyDesktopItems

    (python3.withPackages (p: with p; [ distutils ]))
    node-gyp
    nodejs
    pkg-config
  ];

  # Darwin-specific build and install code adapted from the drawio package, by
  # @darkonion0 and @wegank
  preBuild = ''
    yarn postinstall

    # tries to download a binary which we don't even need
    rm -rf node_modules/electron-chromedriver
    # windows-only, fails to build
    rm -rf node_modules/@vscode/windows-ca-certs
    # tries to download otherwise
    install -D ${ripgrep}/bin/rg -t node_modules/@vscode/ripgrep/bin
    # tries to download electron dist. Doesn't respect
    # ELECTRON_SKIP_BINARY_DOWNLOAD
    substituteInPlace node_modules/@theia/ffmpeg/lib/replace-ffmpeg.js \
      --replace-fail "let shouldDownload = true;" "let shouldDownload = false;" \
      --replace-fail "let shouldReplace = true;" "let shouldReplace = false;"

    # for some reason theia doesn't like the libffmpeg.so from nixpkgs'
    # electron, let's fix that
    sed -Ei -e "s|(KNOWN_PROPRIETARY_CODECS) = .*;$|\1 = new Set([]);|" node_modules/@theia/ffmpeg/lib/check-ffmpeg.js

    # worked like with koodo-reader
    export npm_config_nodedir=${nodejs}
    npm rebuild cpu-features

    export npm_config_nodedir=${electron.headers}
    npm rebuild

    cp -vr ${theiaPlugins}/plugins .
    chmod -R +w plugins

    cp -vr ${electron.dist} node_modules/electron/dist
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -vr ${electron.dist}/Electron.app applications/electron
    chmod -R +w applications/electron/Electron.app
  '';

  postBuild = ''
    yarn run electron electron-builder --dir \
      -c.electronDist=${if stdenv.hostPlatform.isDarwin then "." else electron.dist} \
      -c.electronVersion=${electron.version}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "theia-ide";
      genericName = "Integrated Development Environment";
      desktopName = "Eclipse Theia IDE";
      comment = "Modern and open IDE for cloud and desktop";
      exec = "theia-ide";
      icon = "theia-ide";
      categories = [ "Development" ];
      mimeTypes = [ "inode/directory" ];
    })
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/theia-ide
    cp -vr applications/electron/dist/linux-unpacked/resources $out/share/theia-ide

    # patch redhat.java plugin with a jdk from nixpkgs
    pluginDir=$out/share/theia-ide/resources/app/plugins/redhat.java/extension
    if [ -d "$pluginDir" ]; then
      pushd "$pluginDir"
        rm -rf jre/*
        ln -s ${jdk.home} jre/${jdk.name}

        substituteInPlace server/bin/jdtls \
          --replace-fail '/usr/bin/env python3' ${python3.interpreter}
      popd
    fi

    install -Dm444 \
      applications/electron/resources/icons/LinuxLauncherIcons/512x512.png \
      $out/share/icons/hicolor/512x512/apps/theia-ide.png

    makeWrapper ${lib.getExe electron} $out/bin/theia-ide \
      --add-flag $out/share/theia-ide/resources/app \
      --add-flag --no-sandbox \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}}" \
      --set-default JAVA_HOME "${jdk.home}" \
      --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -vr applications/electron/dist/mac*/TheiaIDE.app $out/Applications
    makeWrapper $out/Applications/TheiaIDE.app/Contents/MacOS/TheiaIDE $out/bin/TheiaIDE
  ''
  + ''
    runHook postInstall
  '';

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    PUPPETEER_SKIP_DOWNLOAD = 1;
  };

  passthru = {
    inherit theiaPlugins;
  };

  meta = {
    description = "Modern and open IDE for cloud and desktop";
    homepage = "https://github.com/eclipse-theia/theia-ide";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "theia-ide";
    inherit (electron.meta) platforms;
  };
}
