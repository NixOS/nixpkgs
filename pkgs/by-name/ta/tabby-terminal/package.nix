{
  lib,
  stdenv,
  fetchFromGitHub,
  prefetch-yarn-deps,
  cacert,
  nodejs,
  yarn,
  fixup-yarn-lock,
  makeWrapper,
  pkg-config,
  python3,
  electron,
  libsecret,
  fontconfig,
  glib,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  version = "1.0.237";

  src = fetchFromGitHub {
    owner = "Eugeny";
    repo = "tabby";
    rev = "v${version}";
    hash = "sha256-O+DHqzz+FsBDMaGAYs+lnFYneo0TyjqXqkhNnncX9o8=";
  };

  offlineCache = stdenv.mkDerivation {
    name = "tabby-offline-${version}";

    nativeBuildInputs = [
      prefetch-yarn-deps
      cacert
    ];

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
    env = {
      GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    };

    dontUnpack = true;
    dontInstall = true;

    buildPhase = ''
      runHook preBuild

      mkdir -p $out
      cd $out

      for lock in \
        ${src}/yarn.lock \
        ${src}/app/yarn.lock \
        ${src}/web/yarn.lock \
        ${src}/tabby-*/yarn.lock
      do
        prefetch-yarn-deps --builder "$lock"
      done

      rm -f yarn.lock

      runHook postBuild
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-Dgsw/xId9qzQ3GSoT1TYiVmMsuimeRtczBTt8MABEYg=";
  };
in
stdenv.mkDerivation {
  pname = "tabby";
  inherit version src offlineCache;

  strictDeps = true;
  __structuredAttrs = true;

  dontPatchShebangs = true;

  nativeBuildInputs = [
    nodejs
    yarn
    fixup-yarn-lock
    makeWrapper
    pkg-config
    python3
    copyDesktopItems
  ];

  buildInputs = [
    electron
    libsecret
    fontconfig
    glib
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "tabby";
      exec = "tabby --no-sandbox %U";
      terminal = false;
      type = "Application";
      icon = "tabby";
      desktopName = "Tabby";
      genericName = "Terminal Emulator";
      comment = "A terminal for a modern age";
      categories = [
        "System"
        "TerminalEmulator"
      ];
      startupWMClass = "tabby";
    })
  ];

  postPatch = ''
    # Remove conflicting resolution breaking Yarn v1 offline mode
    substituteInPlace package.json \
      --replace-fail '    "eslint/strip-ansi": "6.0.0",' ""
    # Stub git describe to provide derivation version
    substituteInPlace scripts/vars.mjs \
      --replace-fail "childProcess.execSync('git describe --tags', { encoding:'utf-8' })" "'v''${version}'"

    # Ensure nested yarn tsc invocations stay offline
    substituteInPlace scripts/build-typings.mjs \
      --replace-fail "yarn tsc" "yarn --offline tsc"

    # Point runtime plugin discovery to Tabby's installation folder
    substituteInPlace app/src/plugins.ts \
      --replace-fail "path.join((process as any).resourcesPath, 'builtin-plugins')" "path.join(remote.app.getAppPath(), 'builtin-plugins')"

    # Restore window control hover styles
    substituteInPlace tabby-core/src/components/windowControls.component.scss \
      --replace-fail "background: transparent !important;" "" \
      --replace-fail "color: inherit !important;" ""
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME="$NIX_BUILD_TOP/tmp-home"
    mkdir -p "$HOME"

    yarn config --offline set yarn-offline-mirror "$offlineCache"

    # 1. Fix up all lockfiles across the monorepo
    for lock in yarn.lock app/yarn.lock web/yarn.lock tabby-*/yarn.lock; do
      fixup-yarn-lock "$lock"
    done

    # 2. Install root dependencies (build tools)
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress install

    # 3. Install app dependencies (runtime modules)
    pushd app
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress install
    popd

    # 4. Install web and plugin dependencies
    for dir in web tabby-*; do
      pushd "$dir"
      yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress install
      popd
    done

    # 5. Symlink plugins into root node_modules for build-time resolution
    pushd node_modules
    for plugin in ../tabby-*; do
      ln -s "$plugin" "$(basename "$plugin")"
    done
    popd

    # 6. Patch shebangs for root build-time tools
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export PATH="$PWD/node_modules/.bin:$PATH"

    # 1. Build TypeScript typings
    yarn --offline run build:typings

    # 2. Bundle application and plugins via Webpack
    yarn --offline run build

    # 3. Apply postinstall patches in app
    pushd app
    yarn --offline run postinstall || true
    popd

    # 4. Compile native modules against Electron headers and immediately prune build artifacts
    for mod in keytar fontmanager-redux native-process-working-directory node-pty; do
      echo "Rebuilding $mod against Electron headers..."
      pushd "app/node_modules/$mod"
      node-gyp rebuild --nodedir="${electron.headers}"
      rm -rf build/Release/obj.target build/Release/.deps build/{Makefile,*.mk,*.gypi}
      popd
    done

    # node-pty leaves build files and prebuilds in subdirectories
    rm -rf app/node_modules/node-pty/{node-addon-api,prebuilds,third_party}

    # 5. Stage built plugins for runtime discovery
    mkdir -p app/builtin-plugins
    for plugin in tabby-*; do
      if [ -d "$plugin/dist" ]; then
        mkdir -p "app/builtin-plugins/$plugin"
        cp -r "$plugin/package.json" "$plugin/dist" "app/builtin-plugins/$plugin/"
        cp -r "$plugin/node_modules" "app/builtin-plugins/$plugin/"
      fi
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/tabby $out/bin $out/share/icons/hicolor/scalable/apps

    # Copy application runtime files
    cp -r app/* $out/share/tabby/

    # Install application icons
    install -Dm644 build/icons/icon.svg $out/share/icons/hicolor/scalable/apps/tabby.svg
    for size in 16 32 64 128 256 512; do
      install -Dm644 "build/icons/''${size}x''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/tabby.png"
    done

    # Wrap system electron to launch the Tabby directory
    makeWrapper ${electron}/bin/electron $out/bin/tabby \
      --add-flags "$out/share/tabby" \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform-hint=auto" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libsecret
          fontconfig
          glib
          stdenv.cc.cc.lib
        ]
      }"

    runHook postInstall
  '';

  postInstall = ''
    # 1. Remove build tools and development dependencies
    rm -rf \
      $out/share/tabby/node_modules/.bin \
      $out/share/tabby/node_modules/@npmcli/run-script/node_modules/.bin \
      $out/share/tabby/node_modules/node-gyp \
      $out/share/tabby/node_modules/patch-package \
      $out/share/tabby/node_modules/@types \
      $out/share/tabby/node_modules/nan

    # 2. Remove Windows/macOS-only packages and foreign prebuilds
    rm -rf \
      $out/share/tabby/node_modules/@tabby-gang \
      $out/share/tabby/node_modules/macos-native-processlist \
      $out/share/tabby/node_modules/windows-native-registry \
      $out/share/tabby/node_modules/glasstron/native/*.exe \
      $out/share/tabby/node_modules/@serialport/bindings-cpp/prebuilds/{android,darwin,win32}* \
      $out/share/tabby/node_modules/russh/russh.{darwin,win32}*.node

    # 3. Remove TypeScript source files, build configs, and sourcemaps
    rm -rf \
      $out/share/tabby/src \
      $out/share/tabby/lib \
      $out/share/tabby/patches \
      $out/share/tabby/tsconfig*.json \
      $out/share/tabby/webpack.config*.mjs \
      $out/share/tabby/*.yml \
      $out/share/tabby/yarn.lock

    rm -f $out/share/tabby/dist/*.map $out/share/tabby/builtin-plugins/*/dist/*.map
  '';

  meta = {
    description = "Terminal for a modern age";
    homepage = "https://tabby.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
    mainProgram = "tabby";
  };
}
