{
  bun,
  copyDesktopItems,
  cctools,
  installShellFiles,
  lib,
  makeBinaryWrapper,
  node-gyp,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  makeDesktopItem,
  python3,
  writableTmpDirAsHomeHook,
  xcbuild,

  electron_40,
  nodejs,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    electron = electron_40;
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

        # Bun stores one directory per resolved version under .bun/. Canonicalize
        # those entries into a stable package-name view before vendoring them.
        bun --bun ${./canonicalize-node-modules.ts}

        # Rebuild .bin symlinks against the canonicalized .bun layout so the
        # vendored node_modules tree keeps deterministic relative targets.
        bun --bun ${./normalize-bun-binaries.ts}

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir --parents $out
        cp --recursive node_modules $out
        find apps packages -type d -name node_modules -exec cp --recursive --parents {} $out \;

        runHook postInstall
      '';

      outputHash = "sha256-yrzdhw+NPYZku10piHoxMy+TUJ8MYySZorMOMOztJY4=";
      outputHashMode = "recursive";
    };
  in
  {
    pname = "t3code";
    version = "0.0.15";
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "pingdotgg";
      repo = "t3code";
      tag = "v${finalAttrs.version}";
      hash = "sha256-HOPiA8X/FzswKGmOuYKog3YIn5iq5rJ/7kDoGhN11x0=";
    };

    postPatch = ''
      substituteInPlace apps/web/vite.config.ts \
        --replace-fail '  server: {' $'  server: {\n    host: "127.0.0.1",' \
        --replace-fail 'host: "localhost"' 'host: "127.0.0.1"'
    '';

    nativeBuildInputs = [
      bun
      copyDesktopItems
      installShellFiles
      makeBinaryWrapper
      node-gyp
      nodejs
      python3
      writableTmpDirAsHomeHook
    ]
    ++ lib.optionals stdenv.buildPlatform.isDarwin [
      cctools.libtool
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

    installPhase = ''
      runHook preInstall

      mkdir --parents "$out"/libexec/t3code/apps/desktop "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode node_modules "$out"/libexec/t3code
      cp --recursive --no-preserve=mode apps/server/{node_modules,dist} "$out"/libexec/t3code/apps/server
      cp --recursive --no-preserve=mode apps/desktop/{node_modules,dist-electron} "$out"/libexec/t3code/apps/desktop

      mkdir --parents "$out"/libexec/t3code/apps/desktop/prod-resources
      install --mode=444 assets/prod/black-universal-1024.png \
        "$out"/libexec/t3code/apps/desktop/prod-resources/icon.png

      find "$out"/libexec/t3code -xtype l -delete

      makeWrapper ${lib.getExe nodejs} "$out"/bin/t3code \
        --add-flags "$out"/libexec/t3code/apps/server/dist/index.mjs

      makeWrapper ${lib.getExe electron} "$out"/bin/t3code-desktop \
        --add-flags "$out"/libexec/t3code/apps/desktop/dist-electron/main.js \
        --inherit-argv0

      mkdir --parents \
        "$out"/share/icons/hicolor/1024x1024/apps \
        "$out"/share/icons/hicolor/scalable/apps
      install --mode=444 assets/prod/black-universal-1024.png \
        "$out"/share/icons/hicolor/1024x1024/apps/t3code.png
      install --mode=444 assets/prod/logo.svg \
        "$out"/share/icons/hicolor/scalable/apps/t3code.svg

      runHook postInstall
    '';

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd t3code \
        --bash <("$out"/bin/t3code --completions bash) \
        --fish <("$out"/bin/t3code --completions fish) \
        --zsh <("$out"/bin/t3code --completions zsh)
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "t3code";
        desktopName = "T3 Code";
        comment = finalAttrs.meta.description;
        exec = "t3code-desktop %U";
        terminal = false;
        icon = "t3code";
        startupWMClass = "T3 Code";
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
      inherit (nodejs.meta) platforms;
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        imalison
        qweered
      ];
      mainProgram = "t3code-desktop";
    };
  }
)
