{
  cctools,
  copyDesktopItems,
  electron_40,
  fetchFromGitHub,
  fetchPnpmDeps,
  installShellFiles,
  lib,
  libicns,
  makeBinaryWrapper,
  makeDesktopItem,
  nix-update-script,
  node-gyp,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  python3,
  stdenv,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  writeDarwinBundle,
  xcbuild,
  enableAzureDevOps ? false,
  azure-cli,
  azure-cli-extensions,
  enableBitbucket ? false,
  bitbucket-cli,
  enableClaude ? false,
  claude-code,
  enableCodex ? true,
  codex,
  enableCursor ? false,
  code-cursor,
  enableCursorAgent ? false,
  cursor-cli,
  enableGitHub ? true,
  gh,
  enableGit ? true,
  git,
  enableGitLab ? false,
  glab,
  enableJujutsu ? false,
  jujutsu,
  enableOpenCode ? true,
  opencode,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    appName = "T3 Code (Alpha)";
    electron = electron_40;
    desktopIcon =
      if stdenv.hostPlatform.isDarwin then
        "assets/prod/black-macos-1024.png"
      else
        "assets/prod/black-universal-1024.png";
    runtimePackages =
      lib.optionals enableAzureDevOps [
        azure-cli.withExtensions
        [ azure-cli-extensions.azure-devops ]
      ]
      ++ lib.optionals enableBitbucket [ bitbucket-cli ]
      ++ lib.optionals enableClaude [ claude-code ]
      ++ lib.optionals enableCodex [ codex ]
      ++ lib.optionals enableCursor [ code-cursor ]
      ++ lib.optionals enableCursorAgent [ cursor-cli ]
      ++ lib.optionals enableGitHub [ gh ]
      ++ lib.optionals enableGit [ git ]
      ++ lib.optionals enableGitLab [ glab ]
      ++ lib.optionals enableJujutsu [ jujutsu ]
      ++ lib.optionals enableOpenCode [ opencode ];
    runtimeBinPath = lib.optionalString enableCursorAgent "$out/libexec/t3code/runtime-bin";
    runtimePath =
      runtimeBinPath
      + lib.optionalString (enableCursorAgent && runtimePackages != [ ]) ":"
      + lib.makeBinPath runtimePackages;
    runtimePathWrapperArgs = lib.optionalString (runtimePath != "") ''
      \
        --prefix PATH : ${runtimePath}
    '';
    patchPackageManager = ''
      substituteInPlace package.json \
        --replace-fail '"packageManager": "pnpm@10.24.0"' \
                       '"packageManager": "pnpm"'
    '';
    nodeModules = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) src version strictDeps;

      nativeBuildInputs = [
        git
        nodejs
        pnpm_10
        pnpmConfigHook
        writableTmpDirAsHomeHook
      ];

      pnpmDeps = fetchPnpmDeps {
        inherit (finalAttrs) pname src version;
        pnpm = pnpm_10;
        fetcherVersion = 3;
        hash = "sha256-Cwzn5LtfJiRKBtV6OpvZ+dxvvjsth99lLcOwfm0s1wc=";
      };

      dontFixup = true;

      postPatch = patchPackageManager;

      buildPhase = ''
        runHook preBuild

        pnpm install \
          --offline \
          --config.node-linker=hoisted \
          --ignore-scripts \
          --frozen-lockfile

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir --parents $out
        cp --recursive node_modules $out
        for packageDir in apps/* oxlint-plugin-t3code packages/* scripts; do
          if [ -d "$packageDir/node_modules" ]; then
            mkdir --parents "$out/$packageDir"
            cp --recursive "$packageDir/node_modules" "$out/$packageDir"
          fi
        done

        runHook postInstall
      '';
    };
  in
  {
    pname = "t3code";
    version = "0.0.25";
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "pingdotgg";
      repo = "t3code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-R9FTqKT67POU9dED/EdPJVsu/rSEQ2C4WoNUwgkL0e8=";
    };

    postPatch = ''
      ${patchPackageManager}

      substituteInPlace apps/web/vite.config.ts \
        --replace-fail 'const host = process.env.HOST?.trim() || "localhost";' \
                       'const host = process.env.HOST?.trim() || "127.0.0.1";'
    '';

    nativeBuildInputs = [
      installShellFiles
      makeBinaryWrapper
      node-gyp
      nodejs
      pnpm_10
      python3
      writableTmpDirAsHomeHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools.libtool
      libicns
      writeDarwinBundle
      xcbuild
    ];

    configurePhase = ''
      runHook preConfigure

      cp --recursive ${nodeModules}/. .

      chmod --recursive u+rwX node_modules
      patchShebangs node_modules

      # Upstream bumps package.json versions after tagging releases, then applies
      # the same bump in the release workflow before building artifacts.
      node scripts/update-release-package-versions.ts ${finalAttrs.version}

      # Compile node-pty's native addon (hoisted into node_modules).
      export npm_config_nodedir=${nodejs}
      cd node_modules/node-pty
      node-gyp rebuild
      node scripts/post-install.js
      cd -

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      pnpm --dir apps/web build
      pnpm --dir apps/server build:bundle
      pnpm --dir apps/desktop exec vp pack

      runHook postBuild
    '';

    # Bun vendors many prebuilt native artifacts for non-host platforms, and
    # some of those binaries are statically linked. Let fixup handle wrappers,
    # shebangs, and stripping, but skip patchelf on the vendored tree.
    dontPatchELF = true;
    # The tmpdir audit hook also shells out to patchelf while scanning every
    # vendored ELF for leaked build paths. That produces spurious warnings on
    # Bun's static foreign-platform binaries.
    noAuditTmpdir = true;

    installPhase = ''
      runHook preInstall

      mkdir --parents "$out"/libexec/t3code/apps/desktop "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode node_modules "$out"/libexec/t3code
      cp --recursive --no-preserve=mode apps/server/dist "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode apps/desktop/dist-electron "$out"/libexec/t3code/apps/desktop

      mkdir --parents "$out"/libexec/t3code/apps/desktop/prod-resources
      install --mode=444 ${desktopIcon} \
        "$out"/libexec/t3code/apps/desktop/prod-resources/icon.png

      find "$out"/libexec/t3code -xtype l -delete

      ${lib.optionalString enableCursorAgent ''
        mkdir --parents "$out"/libexec/t3code/runtime-bin
        ln --symbolic ${lib.getExe cursor-cli} "$out"/libexec/t3code/runtime-bin/agent
      ''}

      makeWrapper ${lib.getExe nodejs} "$out"/bin/t3code \
        --add-flags "$out"/libexec/t3code/apps/server/dist/bin.mjs ${runtimePathWrapperArgs}

      makeWrapper ${lib.getExe electron} "$out"/bin/t3code-desktop \
        --add-flags "$out"/libexec/t3code/apps/desktop/dist-electron/main.cjs \
        --inherit-argv0 ${runtimePathWrapperArgs}
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir --parents "$out/Applications/${appName}.app/Contents/"{MacOS,Resources}
      png2icns \
        "$out/Applications/${appName}.app/Contents/Resources/t3code.icns" \
        ${desktopIcon}

      # writeDarwinBundle is a shebangless bash script; run it explicitly via
      # stdenv.shell to avoid Darwin's intermittent ENOEXEC fallback issues.
      ${stdenv.shell} ${lib.getExe writeDarwinBundle} \
        "$out" "${appName}" t3code-desktop t3code
    ''
    + ''
      mkdir --parents \
        "$out"/share/icons/hicolor/scalable/apps
      install --mode=444 ${desktopIcon} \
        "$out"/share/icons/t3code.png
      install --mode=444 assets/prod/logo.svg \
        "$out"/share/icons/hicolor/scalable/apps/t3code.svg

      runHook postInstall
    '';

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        installShellCompletion --cmd t3code --"$shell" <("$out/bin/t3code" --completions "$shell")
      done
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "t3code";
        desktopName = appName;
        comment = "Minimal web GUI for coding agents";
        exec = "t3code-desktop %U";
        terminal = false;
        icon = "t3code";
        startupWMClass = "t3code";
        categories = [ "Development" ];
      })
    ];

    passthru = {
      inherit nodeModules;
      inherit runtimePackages;
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "nodeModules"
        ];
      };
    };

    meta = {
      description = "Minimal web GUI for coding agents";
      homepage = "https://t3.codes";
      downloadPage = "https://t3.codes/download";
      changelog = "https://github.com/pingdotgg/t3code/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        iamanaws
        qweered
      ];
      mainProgram = "t3code-desktop";
      inherit (nodejs.meta) platforms;
    };
  }
)
