{
  bun,
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
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  writeDarwinBundle,
  xcbuild,
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
    nodeModules = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) src version strictDeps;

      nativeBuildInputs = [
        bun
        nodejs
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;
      dontFixup = true;

      postPatch = ''
        for packageJson in \
          packages/{contracts,shared}/package.json
        do
          substituteInPlace "$packageJson" \
            --replace-fail '"prepare": "effect-language-service patch",' '"prepare": "true",'
        done
      '';

      buildPhase = ''
        runHook preBuild

        bun install \
          --cpu="*" \
          --ignore-scripts \
          --no-progress \
          --frozen-lockfile \
          --os="*"

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir --parents $out
        cp --recursive node_modules $out
        find apps packages -type d -name node_modules -exec cp --recursive --parents {} $out \;

        runHook postInstall
      '';

      outputHash = "sha256-MuP+L8PwV9gKbeiJXYtUpgyIAYPmq4G1FolP7uB9J3w=";
      outputHashMode = "recursive";
    };
  in
  {
    pname = "t3code";
    version = "0.0.21";
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "pingdotgg";
      repo = "t3code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-e0U9DkEh20w1xq4P9Fri3bx2ifCiDK4G/vVPHDP+lXs=";
    };

    postPatch = ''
      substituteInPlace apps/web/vite.config.ts \
        --replace-fail 'const host = process.env.HOST?.trim() || "localhost";' \
                       'const host = process.env.HOST?.trim() || "127.0.0.1";'
    '';

    nativeBuildInputs = [
      bun
      installShellFiles
      makeBinaryWrapper
      node-gyp
      nodejs
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

      # Compile node-pty's native addon from the vendored bun store.
      export npm_config_nodedir=${nodejs}
      cd node_modules/.bun/node-pty@*/node_modules/node-pty
      node-gyp rebuild
      node scripts/post-install.js
      cd -

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      for app in web server desktop; do
        bun run --cwd apps/"$app" build
      done

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
      cp --recursive --no-preserve=mode apps/server/{node_modules,dist} "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode apps/desktop/{node_modules,dist-electron} "$out"/libexec/t3code/apps/desktop

      mkdir --parents "$out"/libexec/t3code/apps/desktop/prod-resources
      install --mode=444 ${desktopIcon} \
        "$out"/libexec/t3code/apps/desktop/prod-resources/icon.png

      find "$out"/libexec/t3code -xtype l -delete

      makeWrapper ${lib.getExe nodejs} "$out"/bin/t3code \
        --add-flags "$out"/libexec/t3code/apps/server/dist/bin.mjs

      makeWrapper ${lib.getExe electron} "$out"/bin/t3code-desktop \
        --add-flags "$out"/libexec/t3code/apps/desktop/dist-electron/main.cjs \
        --inherit-argv0
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir --parents "$out/Applications/${appName}.app/Contents/"{MacOS,Resources}
      png2icns \
        "$out/Applications/${appName}.app/Contents/Resources/t3code.icns" \
        ${desktopIcon}
      write-darwin-bundle "$out" "${appName}" t3code-desktop t3code
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
