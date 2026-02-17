{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  runCommand,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  writeShellScript,
  electron,
  nodejs_22, # npm_config_nodedir — node-gyp ABI must match electron's Node 22
  nodejs_24,
  yarn,
  python3,
  pkg-config,
  dotnet-sdk_9,
  dotnetCorePackages,
  libsecret,
  autoPatchelfHook,
  jq,
  clang,
  zlib,
}: let
  nugetDeps = dotnetCorePackages.mkNugetDeps {
    name = "vortex-fomod";
    sourceFile = ./nuget-deps.json;
  };

  nativeAddons = import ./native-addons.nix {inherit lib;};
  fomod = import ./fomod.nix {inherit lib;};

  # Native AOT handles FOMOD without .NET runtime — probe always succeeds
  dotnetprobeStub = writeShellScript "dotnetprobe" "exit 0";

  # Shared yarn install flags (used for root, extensions, app, and FOMOD deps)
  yarnFlags = lib.concatStringsSep " " [
    "--force"
    "--ignore-engines"
    "--ignore-platform"
    "--ignore-scripts"
    "--no-progress"
    "--non-interactive"
    "--offline"
  ];

  # Glob patterns for cross-platform native modules to strip from output
  stripPatterns = [
    "*-musl"
    "*-arm64*"
    "*-arm-*"
    "*-arm*-*"
    "*-freebsd*"
    "*-android*"
    "*-win32*"
    "*-darwin*"
    "*-ia32*"
    "fsevents"
  ];

  stripFindArgs = lib.concatStringsSep " -o " (map (p: "-name '${p}'") stripPatterns);
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "vortex";
    version = "1.16.3";

    src = fetchFromGitHub {
      owner = "Nexus-Mods";
      repo = "Vortex";
      rev = "v${finalAttrs.version}";
      hash = "sha256-yeZgmfvHjhpXmZm6/Gvw/X9pVVvYaQ7p1dIiwRTy2As=";
      fetchSubmodules = true;
    };

    mergedYarnLock = import ./yarn-lock.nix {
      inherit runCommand fixup-yarn-lock;
      inherit (finalAttrs) src;
      nodejs = nodejs_24;
    };

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = finalAttrs.mergedYarnLock;
      hash = "sha256-PtJo301oFAKtgh61WRJglXIhT6l0QGSFaSvPUw1V6LM=";
    };

    nativeBuildInputs = [
      nodejs_24
      yarn
      fixup-yarn-lock
      python3
      pkg-config
      dotnet-sdk_9
      clang
      autoPatchelfHook
      copyDesktopItems
      makeWrapper
    ];

    buildInputs = [
      libsecret
      (lib.getLib stdenv.cc.cc)
      nugetDeps
      zlib
    ];

    # Musl-linked prebuilds ship in the asar but can't be satisfied on glibc
    autoPatchelfIgnoreMissingDeps = ["libc.musl-x86_64.so.1"];

    postPatch = ''
      # The resolutions field causes yarn to do fresh NpmResolver lookups in
      # offline mode which fails. The lockfile already has correct versions.
      ${lib.getExe jq} 'del(.resolutions["**/dir-compare/minimatch"])' package.json > package.json.tmp
      mv package.json.tmp package.json

      # BuildSubprojects.js runs yarn install then build in each extension dir.
      # Skip the install step since we pre-install everything in configurePhase.
      substituteInPlace BuildSubprojects.js \
        --replace-fail \
          'npm("install", instArgs, { cwd: project.path }, feedback).then(() =>' \
          'Promise.resolve().then(() =>'

      # Make individual extension build failures non-fatal. Some extensions
      # (e.g. modtype-umm) reference generated code missing from the release tarball.
      substituteInPlace BuildSubprojects.js \
        --replace-fail \
          'failed = true;' \
          '/* failed = true; */'
    '';

    env = {
      ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
      VORTEX_SKIP_SUBMODULES = "1";
      VORTEX_SKIP_PREINSTALL = "1";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      DOTNET_NOLOGO = "1";
      DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
      npm_config_nodedir = "${nodejs_22}";
    };

    configurePhase = ''
      runHook preConfigure

      export HOME=$(mktemp -d)

      # The dotnet-sdk setup hook places full package content in
      # $NUGET_FALLBACK_PACKAGES but MSBuild resolves .targets from $NUGET_PACKAGES.
      if [ -n "''${NUGET_FALLBACK_PACKAGES:-}" ] && [ -d "$NUGET_FALLBACK_PACKAGES" ]; then
        for pkg in "$NUGET_FALLBACK_PACKAGES"/*/; do
          pkgname=$(basename "$pkg")
          [ -d "$NUGET_PACKAGES/$pkgname" ] || cp -r "$pkg" "$NUGET_PACKAGES/$pkgname"
        done
        chmod -R u+w "$NUGET_PACKAGES"
      fi

      # Patch ILC binary for NixOS (hardcoded /lib64 interpreter won't work)
      for ilc in "$NUGET_PACKAGES"/runtime.linux-x64.microsoft.dotnet.ilcompiler/*/tools/ilc; do
        if [ -f "$ilc" ] && ! patchelf --print-interpreter "$ilc" 2>/dev/null | grep -q /nix/store; then
          echo "Patching ILC binary: $ilc"
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$ilc"
          patchelf --set-rpath "$(patchelf --print-rpath "$ilc"):${lib.makeLibraryPath [stdenv.cc.cc zlib]}" "$ilc"
        fi
      done

      # Copy offline cache to writable location
      cp -r "$yarnOfflineCache" "$HOME/offline"
      chmod -R u+w "$HOME/offline"

      yarn config --offline set ignore-engines true
      yarn config --offline set yarn-offline-mirror "$HOME/offline"

      find . -name yarn.lock -exec fixup-yarn-lock {} \;

      # --- Root dependencies ---
      yarn install --frozen-lockfile --production=false ${yarnFlags}
      patchShebangs node_modules

      # --- Native addons (--ignore-scripts skipped their install hooks) ---
      ${nativeAddons.buildScript}

      # --- Extension dependencies ---
      for lockfile in extensions/*/yarn.lock; do
        dir=$(dirname "$lockfile")
        echo "Installing deps in $dir"
        pushd "$dir"
        yarn install ${yarnFlags} || true
        patchShebangs node_modules 2>/dev/null || true
        popd
      done

      # --- FOMOD TypeScript dependencies ---
      ${fomod.installDeps}

      # --- App dependencies ---
      pushd app
      yarn install --frozen-lockfile --production=false ${yarnFlags}
      patchShebangs node_modules
      ${nativeAddons.copyToAppScript}
      popd

      runHook postConfigure
    '';

    preBuild = ''
      # Prepare electron dist for electron-builder
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist

      # --- FOMOD builds ---
      ${fomod.buildIPC}
      ${fomod.buildNativeAOT}
      ${fomod.syncDists}
    '';

    buildPhase = ''
      runHook preBuild

      yarn --offline build
      # Some extensions may fail (e.g. modtype-umm references generated code
      # missing from the release tarball). Non-fatal.
      yarn --offline subprojects_app || true
      yarn --offline _assets_app
      yarn --offline build_dist

      yarn electron-builder \
        --config electron-builder-config.json \
        --publish never \
        --linux dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/vortex
      cp -r dist/linux*-unpacked/resources $out/opt/vortex/

      install -Dm755 ${dotnetprobeStub} \
        $out/opt/vortex/resources/app.asar.unpacked/assets/dotnetprobe

      install -Dm644 assets/images/vortex.png \
        $out/share/icons/hicolor/256x256/apps/vortex.png

      makeWrapper ${electron}/bin/electron $out/bin/vortex \
        --add-flags $out/opt/vortex/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --set GTK_USE_PORTAL 0 \
        --set IGNORE_UPDATES yes

      # Strip unused cross-platform native modules
      # maxdepth 2 catches scoped packages like @parcel/watcher-darwin-x64
      find $out/opt/vortex/resources/app.asar.unpacked/node_modules -maxdepth 2 -type d \
        \( ${stripFindArgs} \) \
        -exec rm -rf {} +

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "vortex";
        desktopName = "Vortex";
        comment = "Mod manager from Nexus Mods";
        exec = "vortex --download %u";
        icon = "vortex";
        startupWMClass = "Vortex";
        categories = ["Game"];
        mimeTypes = ["x-scheme-handler/nxm"];
      })
    ];

    meta = {
      description = "The elegant, powerful, and open-source mod manager from Nexus Mods";
      homepage = "https://www.nexusmods.com/about/vortex/";
      changelog = "https://github.com/Nexus-Mods/Vortex/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ caniko ];
      mainProgram = "vortex";
      platforms = ["x86_64-linux"];
    };
  })
