{
  lib,
  stdenv,
  autoPatchelfHook,
  copyDesktopItems,
  dotnetCorePackages,
  electron_43,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchpatch,
  fetchurl,
  fontconfig,
  gitMinimal,
  makeDesktopItem,
  makeWrapper,
  node-gyp,
  nodejs_24,
  pnpm_11,
  pnpmConfigHook,
  pkg-config,
  python3,
  steam-run-free,
  writeShellScript,
}:

let
  pnpm = pnpm_11.override { nodejs-slim = nodejs_24; };
  electron = electron_43;

  levelPivot = fetchurl {
    url = "https://nexus-mods.github.io/duckdb-level-pivot/current_release/v1.5.1/linux_amd64/level_pivot.duckdb_extension.gz";
    hash = "sha256-+CKjeCbhl1VXrv+7MPwaea1KEEi0VaQpugtr8DEBMGU=";
  };

  # FIXME: Upstream's pnpm-lock currently contains multiple Nexus-Mods/7z-bin pins.
  # Most are handled correctly by pnpm-github-dependencies, however this one is not:
  #
  # TODO: Replace all `Nexus-Mods/7z-bin` dependencies with a Nix-provided compatibility
  # package that exports the path to pkgs._7zz (or pkgs._7zz-rar if targeting `unfree`).
  # See https://github.com/Nexus-Mods/7z-bin/blob/master/index.js
  legacy7zDependency = fetchurl {
    name = "7z-bin-legacy.tar.gz";
    url = "https://codeload.github.com/Nexus-Mods/7z-bin/tar.gz/025786f01319526b56400b0410af6268adc1125c";
    hash = "sha256-Tf84krgoWQSh/1yH0DO5Fik83fTq1iYkguZVQwxKAXw=";
    meta = gitDependencyMetaOverrides."Nexus-Mods/7z-bin";
  };

  dotnetProbe = writeShellScript "dotnetprobe" ''
    requiredMajor="''${1:-9}"
    version=""
    while read -r runtime candidate _; do
      if [[ "$runtime" == "Microsoft.NETCore.App" ]]; then
        version="$candidate"
      fi
    done < <(${dotnetCorePackages.runtime_9_0}/bin/dotnet --list-runtimes)
    if [[ -z "$version" ]]; then
      echo "Error: Could not find the .NET runtime" >&2
      exit 1
    fi
    actualMajor="''${version%%.*}"
    if (( actualMajor < requiredMajor )); then
      echo "Error: Requires .NET $requiredMajor or higher but found .NET $version" >&2
      exit 1
    fi
    echo "Success: Found .NET $version"
  '';

  gitDependencyMetaOverrides = {
    "Nexus-Mods/7z-bin" = {
      license = with lib.licenses; [
        lgpl2Plus
        bsd3
        unfreeRedistributable
      ];
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vortex";
  version = "2.4.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Nexus-Mods";
    repo = "Vortex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d27HT1w5NlQ4eS5OcotlNmimGbhDV3kCz34J/qHxUD8=";
  };

  patches = [
    # Backport the upstream fix that makes API type generation reproducible.
    (fetchpatch {
      url = "https://github.com/Nexus-Mods/Vortex/commit/012a3ca7ddc50607aff8df38e092255ee577d949.patch";
      hash = "sha256-MGOCJyYEV/PRu4D12QuuVW9JQPYndKEITd87QRn7raQ=";
    })
  ];

  pnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-pnpm-deps";
    inherit (finalAttrs) version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-iTeMC/DnMwKN3DhWMikywKcrExmmAcYl6tzmCPt7noY=";
  };

  # pnpm's deploy command needs the original archives for Git-hosted
  # dependencies. fetchPnpmDeps installs their contents but does not retain
  # those archives in the form deploy expects.
  gitDependencies = lib.forEach (lib.importJSON ./pnpm-github-dependencies.json) (dep: {
    inherit (dep) repository revision;
    archive = fetchurl {
      inherit (dep) url hash;
      name = "${lib.replaceString "/" "-" dep.repository}.tar.gz";
      meta = gitDependencyMetaOverrides.${dep.repository} or { };
    };
  });

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    gitMinimal
    makeWrapper
    node-gyp
    nodejs_24
    pnpm
    pnpmConfigHook
    pkg-config
    (python3.withPackages (ps: [ ps.setuptools ]))
  ];

  buildInputs = [
    fontconfig
    (lib.getLib stdenv.cc.cc)
  ];

  env = {
    CI = "1";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NO_PARALLEL = "1";
    NX_DAEMON = "false";
    NX_TASKS_RUNNER_DYNAMIC_OUTPUT = "false";
    PNPM_CONFIG_REPORTER = "append-only";
    VORTEX_SKIP_SUBMODULES = "1";
    VORTEX_VERSION = finalAttrs.version;
    npm_config_runtime = "electron";
    npm_config_target = electron.version;
    npm_config_nodedir = electron.headers;
  };

  postPatch = ''
    pinGitDependency() {
      local repository="$1"
      local revision="$2"
      local archive="$3"

      substituteInPlace pnpm-workspace.yaml \
        --replace-fail \
          "github:$repository#$revision" \
          "file:$archive"
      substituteInPlace pnpm-lock.yaml \
        --replace-fail \
          "github:$repository#$revision" \
          "file:$archive" \
        --replace-fail \
          "https://codeload.github.com/$repository/tar.gz/$revision" \
          "file:$archive"
    }

    ${lib.concatMapStringsSep "\n" (
      dep:
      lib.escapeShellArgs [
        "pinGitDependency"
        dep.repository
        dep.revision
        dep.archive
      ]
    ) finalAttrs.gitDependencies}

    # Special case for 7zip:
    substituteInPlace pnpm-lock.yaml \
      --replace-fail \
        "https://codeload.github.com/Nexus-Mods/7z-bin/tar.gz/025786f01319526b56400b0410af6268adc1125c" \
        "file:${legacy7zDependency}"

    substituteInPlace src/main/package.json \
      --replace-fail '"version": "1.0.0"' '"version": "${finalAttrs.version}"'

    # Packaged NXM handler is vortex-nxm.desktop; do not write a user-local one.
    substituteInPlace src/renderer/src/util/protocolRegistration/linux/nxm.ts \
      --replace-fail \
        'return process.defaultApp === true || process.env.NODE_ENV === "development";' \
        'return false;'

    # Generic Linux Proton binaries need NixOS' FHS runner.
    substituteInPlace src/renderer/src/util/linux/proton.ts \
      --replace-fail \
        'executable: path.join(protonPath, "proton"),' \
        'executable: process.env.VORTEX_PROTON_WRAPPER || path.join(protonPath, "proton"),' \
      --replace-fail \
        'args: ["run", exePath, ...args],' \
        'args: process.env.VORTEX_PROTON_WRAPPER ? [path.join(protonPath, "proton"), "run", exePath, ...args] : ["run", exePath, ...args],'

    # Only prepare the extension used by the Linux build.
    substituteInPlace src/main/duckdb-extensions.json \
      --replace-fail \
        '"platforms": ["windows_amd64", "linux_amd64"]' \
        '"platforms": ["linux_amd64"]'

    mkdir -p src/main/build/duckdb-extensions/v1.5.1/linux_amd64
    gzip -dc ${levelPivot} > src/main/build/duckdb-extensions/v1.5.1/linux_amd64/level_pivot.duckdb_extension

    # This is equivalent to upstream's small, network-built .NET version probe.
    mkdir -p tools/dotnetprobe/dist
    cp ${dotnetProbe} tools/dotnetprobe/dist/dotnetprobe
    substituteInPlace tools/dotnetprobe/project.json \
      --replace-fail \
        '"command": "pnpm exec node ./build.mjs"' \
        '"command": "test -x ./dist/dotnetprobe"'

    # These optional integrations fetch unversioned Windows executables during
    # their builds. Do not perform those downloads in the Nix sandbox.
    substituteInPlace extensions/mtframework-arc-support/package.json \
      --replace-fail \
        '"build": "node build.mjs && node download_arctool.js && pnpm extractInfo"' \
        '"build": "node build.mjs && pnpm extractInfo"'
    substituteInPlace extensions/quickbms-support/package.json \
      --replace-fail \
        '"build": "node build.mjs && node download_dependencies.js && pnpm extractInfo"' \
        '"build": "node build.mjs && pnpm extractInfo"'
  '';

  buildPhase = ''
    runHook preBuild

    node-gyp rebuild \
      --directory extensions/theme-switcher/node_modules/font-scanner

    pnpm cross-env NODE_ENV=production \
      pnpm nx run @vortex/main:build --output-style=stream --parallel=1

    # Do not bundle plugins that cannot be built reproducibly on Linux.
    rm -rf \
      src/main/build/bundledPlugins/gamebryo-archive-check \
      src/main/build/bundledPlugins/gamebryo-plugin-indexlock \
      src/main/build/bundledPlugins/mtframework-arc-support \
      src/main/build/bundledPlugins/quickbms-support

    pushd src/main
    pnpm cross-env \
      pnpm_config_inject_workspace_packages=true \
      pnpm_config_ignore_scripts=true \
      pnpm_config_node_linker=hoisted \
      pnpm_config_offline=true \
      pnpm -F @vortex/main deploy ./dist
    node dist/prepare-dist-package.mjs

    pushd dist
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    ../node_modules/.bin/electron-builder \
      --config ./electron-builder.config.json \
      --publish never \
      --linux dir \
      --x64 \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.compression=store
    popd
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/vortex"
    cp -r dist/linux-unpacked/resources "$out/share/vortex/"
    find "$out/share/vortex" -type f -name '*.musl.node' -delete
    install -Dm755 ${dotnetProbe} \
      "$out/share/vortex/resources/app.asar.unpacked/assets/dotnetprobe"

    makeWrapper ${lib.getExe electron} "$out/bin/vortex" \
      --add-flags "$out/share/vortex/resources/app.asar" \
      --unset ELECTRON_RUN_AS_NODE \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          (lib.getLib stdenv.cc.cc)
          stdenv.cc.cc.libgcc
        ]
      } \
      --set DOTNET_ROOT ${dotnetCorePackages.runtime_9_0}/share/dotnet \
      --set ELECTRON_TRASH gio \
      --set IGNORE_UPDATES yes \
      --set VORTEX_PROTON_WRAPPER ${lib.getExe steam-run-free} \
      --inherit-argv0

    makeWrapper "$out/bin/vortex" "$out/bin/vortex-nxm" \
      --add-flags --download

    install -Dm644 assets/images/vortex.png \
      "$out/share/icons/hicolor/256x256/apps/vortex.png"

    runHook postInstall
  '';

  preFixup = ''
    restoreDuckDbExtension() {
      # DuckDB verifies a signed metadata footer. patchelf changes the file and
      # invalidates that footer, so restore it after autoPatchelf has run.
      gzip -dc ${levelPivot} > \
        "$out/share/vortex/resources/app.asar.unpacked/duckdb-extensions/v1.5.1/linux_amd64/level_pivot.duckdb_extension"
    }
    postFixupHooks+=(restoreDuckDbExtension)
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vortex";
      desktopName = "Vortex";
      genericName = "Mod Manager";
      comment = "Mod manager for PC games from Nexus Mods";
      exec = "vortex";
      icon = "vortex";
      categories = [
        "Game"
      ];
      startupWMClass = "Vortex";
      keywords = [
        "mod"
        "mods"
        "modding"
        "nexus"
        "games"
      ];
    })
    (makeDesktopItem {
      name = "vortex-nxm";
      desktopName = "Vortex NXM Handler";
      noDisplay = true;
      exec = "vortex-nxm %u";
      mimeTypes = [ "x-scheme-handler/nxm" ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Open-source mod manager from Nexus Mods";
    homepage = "https://github.com/Nexus-Mods/Vortex";
    changelog = "https://github.com/Nexus-Mods/Vortex/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Only
      unfreeRedistributable
    ];
    mainProgram = "vortex";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [
      caniko
      MattSturgeon
    ];
    longDescription = ''
      Vortex's native Linux build is pre-alpha software. It lacks some of the
      features available in the Windows build, including complete Wine/Proton
      integration and portal-backed file pickers. The ArcTool and QuickBMS
      integrations are omitted because upstream does not provide versioned
      artifacts for their bundled Windows executables.
    '';
  };
})
