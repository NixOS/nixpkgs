{
  cctools,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeBinaryWrapper,
  nix-update,
  node-gyp,
  nodejs,
  python3,
  stdenv,
  writeShellScript,
  xcbuild,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  pnpmBuildHook,
  cacert,
  enableDesktop ? false,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    pnpm = pnpm_11;

  in
  {
    pname = "t3code-unwrapped";
    version = "0.0.34";
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "pingdotgg";
      repo = "t3code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-dS9sDlvepbQe8ATAU/DANGcyBk+BX2mxPaoljeIUn48=";
    };

    postPatch = ''
      substituteInPlace apps/web/vite.config.ts \
        --replace-fail 'const host = explicitHost || "localhost";' \
                       'const host = explicitHost || "127.0.0.1";'
    ''
    + lib.optionalString enableDesktop ''
      # Keep the desktop-only files in a separate output tree while reusing
      # the server-only package as the desktop backend.
      substituteInPlace apps/desktop/src/app/DesktopEnvironment.ts \
        --replace-fail \
          'const serverRoot =' \
          'const serverRoot = process.env.T3CODE_SERVER_ROOT ? process.env.T3CODE_SERVER_ROOT :'
    ''
    + lib.optionalString (!enableDesktop) ''
      # `build:desktop` builds the server and desktop workspaces together;
      # server-only builds drop the desktop workspace from the filters.
      substituteInPlace package.json \
        --replace-fail '--filter @t3tools/desktop --filter t3 build' '--filter t3 build'
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools.libtool
      xcbuild
    ];

    pnpmWorkspaces = [
      # `...` suffix is used to also include other workspace packages that are
      # directly or indirectly depended on by the listed packages, such as
      # `@t3tools/contracts` and `@t3tools/shared`.
      "@t3tools/monorepo"
      "t3..."
      "@t3tools/scripts..."
    ]
    ++ lib.optionals enableDesktop [ "@t3tools/desktop..." ];

    pnpmDeps = fetchPnpmDeps {
      inherit pnpm;
      inherit (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        ;

      fetcherVersion = 4;
      hash =
        if enableDesktop then
          "sha256-y/sJIluwbn65APmJ2p07FK1ScXpetCloTHtQzZMchDU="
        else
          "sha256-50m7xmI66AlTVLBwOtX7RmTdazJgxzrdXi9FGvRwnrk=";
    };

    preBuild = ''
      # pnpm 11 otherwise detects the package version updates below as
      # dependency drift and runs another install, including lifecycle scripts.
      export pnpm_config_verify_deps_before_run=false

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

    ''
    + lib.optionalString (!enableDesktop) ''
      mkdir --parents "$out"/libexec/t3code/apps
      pnpm --offline --config.inject-workspace-packages=true \
        --filter t3 deploy --prod "$out"/libexec/t3code/apps/server

      find "$out"/libexec/t3code -xtype l -delete

      makeWrapper ${lib.getExe nodejs} "$out"/bin/t3 \
        --add-flags "$out"/libexec/t3code/apps/server/dist/bin.mjs
    ''
    + lib.optionalString enableDesktop ''
      mkdir --parents "$out"/libexec/t3code-desktop/apps/desktop
      cp --recursive --no-preserve=mode node_modules "$out"/libexec/t3code-desktop
      cp --recursive --no-preserve=mode \
        apps/desktop/{package.json,node_modules,dist-electron} \
        "$out"/libexec/t3code-desktop/apps/desktop

      mkdir --parents "$out"/libexec/t3code-desktop/apps/desktop/prod-resources
      install --mode=444 ${
        if stdenv.hostPlatform.isDarwin then
          "assets/prod/black-macos-1024.png"
        else
          "assets/prod/black-universal-1024.png"
      } "$out"/libexec/t3code-desktop/apps/desktop/prod-resources/icon.png

      find "$out"/libexec/t3code-desktop -xtype l -delete
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # node-pty tries to chmod this helper at runtime, but the Nix store is
      # immutable by then.
      find "$out"/libexec \
        -path '*/node-pty/prebuilds/darwin-*/spawn-helper' \
        -exec chmod 755 {} +
    ''
    + ''
      runHook postInstall
    '';

    postInstall =
      lib.optionalString (!enableDesktop && stdenv.buildPlatform.canExecute stdenv.hostPlatform)
        ''
          for shell in bash fish zsh; do
            installShellCompletion --cmd t3 --"$shell" <("$out/bin/t3" --completions "$shell")
          done
        '';

    passthru = {
      updateScript = writeShellScript "t3code-update" ''
        set -eu
        ${lib.getExe nix-update} t3code-cli.unwrapped --use-github-releases
        ${lib.getExe nix-update} t3code-desktop.unwrapped --version=skip --no-src
      '';
    };

    meta = {
      homepage = "https://t3.codes";
      downloadPage = "https://t3.codes/download";
      changelog = "https://github.com/pingdotgg/t3code/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        iamanaws
        qweered
      ];
      inherit (nodejs.meta) platforms;
    };
  }
)
