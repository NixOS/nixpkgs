{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,

  copyDesktopItems,
  fetchYarnDeps,
  makeDesktopItem,
  writableTmpDirAsHomeHook,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,

  libsecret,
  libx11,
  libxkbfile,
  cctools,
  clang_20,

  electron_42,
  jdk,
  nodejs,
  vscode-extensions,
  unzip,

  cacert,
  node-gyp,
  pkg-config,
  python3,
  ripgrep,

  nix-update-script,
}:
let
  electron = electron_42;

  version = "1.74.100";

  src = fetchFromGitHub {
    owner = "eclipse-theia";
    repo = "theia-ide";
    tag = "v${version}";
    hash = "sha256-cLQBS7fNOfUi+dforrRG/0M1RQDJYhc6q+MPCLV49J4=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-VK/KwhL+/gvNb7v0bBBwoy4L7o3XxfXvqJzjKZLd8Zc=";
  };

  vscodeBuiltinExtensions = stdenv.mkDerivation (finalAttrs: {
    pname = "vscode-builtin-extensions";
    version = "1.108.2";
    src = fetchzip {
      url = "https://github.com/eclipse-theia/vscode-builtin-extensions/releases/download/${finalAttrs.version}/vscode-builtin-extensions-${finalAttrs.version}.tar.gz";
      hash = "sha256-2Yso4jLvDTGdHXSQFgLRIX3+afymyuWUUnpZPqkTdXY=";
      stripRoot = false;
    };

    nativeBuildInputs = [
      unzip
    ];

    buildPhase = ''
      runHook preBuild

      mkdir target
      export target="$(pwd)/target"
      pushd $src
        for file in *.vsix
        do
          mkdir "$target/''${file%.vsix}"
          unzip "$file" -d "$target/''${file%.vsix}"
        done
      popd

      # These extensions are specifically excluded upstream
      rm -r $target/ms-vscode.js-debug-companion
      rm -r $target/vscode.extension-editing

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/plugins
      for extension in $target/*
      do
        mv "$extension/extension" "$out/plugins/$(basename "$extension")"
      done

      runHook postInstall
    '';
  });
in

stdenv.mkDerivation {
  pname = "theia-ide";
  inherit version src yarnOfflineCache;

  buildInputs = [
    libx11
    libxkbfile
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    clang_20 # clang_21 breaks gyp builds
  ];

  # Darwin-specific build and install code adapted from the drawio package
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

    cp -vr ${vscodeBuiltinExtensions}/plugins .
    chmod -R +w plugins
    ln -s ${vscode-extensions.vscjava.vscode-java-pack}/share/vscode/extensions/vscjava.vscode-java-pack plugins/
    ln -s ${vscode-extensions.vscjava.vscode-java-dependency}/share/vscode/extensions/vscjava.vscode-java-dependency plugins/

    cp -vr ${electron.dist} node_modules/electron/dist
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # trick theia install check into thinking electron is also there on darwin
    chmod -R +w node_modules/electron/dist
    touch node_modules/electron/dist/version

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
    cp -vr applications/electron/dist/linux*-unpacked/resources $out/share/theia-ide

    install -Dm444 \
      applications/electron/resources/icons/LinuxLauncherIcons/512x512.png \
      $out/share/icons/hicolor/512x512/apps/theia-ide.png

    makeWrapper ${lib.getExe electron} $out/bin/theia-ide \
      --add-flag $out/share/theia-ide/resources/app.asar \
      --add-flag --no-sandbox \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}}" \
      --set-default JAVA_HOME "${jdk.home}" \
      --set-default THEIA_PLUGINS local-dir:$out/share/theia-ide/resources/app/plugins \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]} \
      --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -vr applications/electron/dist/mac*/TheiaIDE.app $out/Applications
    makeWrapper $out/Applications/TheiaIDE.app/Contents/MacOS/TheiaIDE $out/bin/TheiaIDE \
      --add-flag --plugins=local-dir:$out/share/theia-ide/resources/app/plugins
  ''
  + ''
    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    PUPPETEER_SKIP_DOWNLOAD = 1;
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(\\d+)\\.(\\d+)\\.(\\d+)"
      ];
    };
  };

  meta = {
    description = "Modern and open IDE for cloud and desktop";
    homepage = "https://github.com/eclipse-theia/theia-ide";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chvp ];
    mainProgram = "theia-ide";
    inherit (electron.meta) platforms;
  };
}
