{
  cctools,
  copyDesktopItems,
  electron_40,
  fetchFromGitHub,
  installShellFiles,
  lib,
  libicns,
  makeBinaryWrapper,
  makeDesktopItem,
  nix-update-script,
  node-gyp,
  nodejs,
  python3,
  stdenv,
  writeDarwinBundle,
  xcbuild,
  fetchPnpmDeps,
  pnpm_10,
  pnpmConfigHook,
  pnpmBuildHook,
  cacert,
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
  enableCursorCli ? false,
  cursor-cli,
  enableGitHub ? true,
  gh,
  enableGit ? true,
  git,
  enableGitLab ? false,
  glab,
  enableJujutsu ? false,
  jujutsu,
  enableOpencode ? false,
  opencode,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    appName = "T3 Code (Alpha)";
    electron = electron_40;
    pnpm = pnpm_10;
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
      ++ lib.optionals enableCursorCli [ cursor-cli ]
      ++ lib.optionals enableGitHub [ gh ]
      ++ lib.optionals enableGit [ git ]
      ++ lib.optionals enableGitLab [ glab ]
      ++ lib.optionals enableJujutsu [ jujutsu ]
      ++ lib.optionals enableOpencode [ opencode ];

    runtimePathWrapperArgs = lib.optionalString (runtimePackages != [ ]) ''
      \
        --prefix PATH : ${lib.makeBinPath runtimePackages}
    '';
  in
  {
    pname = "t3code";
    version = "0.0.27";
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "pingdotgg";
      repo = "t3code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-KwiF6A7pTlkzr43FJ9XM+oEXBOEtw3vrazVOjBaD5lU=";
    };

    postPatch = ''
      substituteInPlace apps/web/vite.config.ts \
        --replace-fail 'const host = process.env.HOST?.trim() || "localhost";' \
                       'const host = process.env.HOST?.trim() || "127.0.0.1";'
    '';

    nativeBuildInputs = [
      installShellFiles
      makeBinaryWrapper
      node-gyp
      nodejs
      python3
      pnpmConfigHook
      pnpmBuildHook
      pnpm
      cacert
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools.libtool
      libicns
      writeDarwinBundle
      xcbuild
    ];

    pnpmWorkspaces = [
      # `...` suffix is used to also include other workspace packages that are
      # directly or indirectly depended on by the listed packages, such as
      # `@t3tools/contracts` and `@t3tools/shared`.
      "@t3tools/monorepo"
      "t3..."
      "@t3tools/desktop..."
      "@t3tools/scripts..."
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit pnpm;
      inherit (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        ;

      fetcherVersion = 4;
      hash = "sha256-vpL0kjDAtxnBpm+izcJ06KXuzX888yxmzrcEc9yKtm0=";
    };

    # This workaround turns the `pnpmWorkspaces` array into a space-separated
    # string. This format is supported by both `pnpmConfigHook` and `pnpmBuildHook`.
    # TODO: remove this when`pnpmConfigHook` supports `___structuredAttrs = true;`
    # https://github.com/NixOS/nixpkgs/issues/528547
    preConfigure = ''
      __pnpmWorkspaces="''${pnpmWorkspaces[@]}"
      unset pnpmWorkspaces
      declare -g pnpmWorkspaces="$__pnpmWorkspaces"
    '';

    preBuild = ''
      node scripts/update-release-package-versions.ts ${finalAttrs.version}

      export npm_config_nodedir=${nodejs}
      export ELECTRON_SKIP_BINARY_DOWNLOAD=1
      # Exclude the `@t3tools/monorepo` workspace from the pending rebuild since
      # `vp config` needs git
      pnpm rebuild --pending "''${pnpmInstallFlags[@]}" --filter '!@t3tools/monorepo'
    '';

    pnpmBuildScript = "build:desktop";

    postBuild = ''
      pnpm vp cache clean
    '';

    # Many dependencies vendors many prebuilt native artifacts for non-host
    # platforms, and some of those binaries are statically linked. Let fixup
    # handle wrappers, shebangs, and stripping, but skip patchelf on the
    # vendored tree.
    dontPatchELF = true;
    # The tmpdir audit hook also shells out to patchelf while scanning every
    # vendored ELF for leaked build paths. That produces spurious warnings on
    # some dependencies' static foreign-platform binaries.
    noAuditTmpdir = true;

    installPhase = ''
      runHook preInstall

      mkdir --parents "$out"/libexec/t3code/apps/desktop "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode node_modules "$out"/libexec/t3code
      cp --recursive --no-preserve=mode apps/server/{node_modules,dist} "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode apps/desktop/{node_modules,dist-electron} "$out"/libexec/t3code/apps/desktop

      mkdir --parents "$out"/libexec/t3code/apps/desktop/prod-resources
      install --mode=444 ${desktopIcon} \
        "$out"/libexec/t3code/apps/desktop/prod-resources/icon.png

      find "$out"/libexec/t3code -xtype l -delete

      makeWrapper ${lib.getExe nodejs} "$out"/bin/t3 \
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
        installShellCompletion --cmd t3 --"$shell" <("$out/bin/t3" --completions "$shell")
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
      updateScript = nix-update-script { };
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
