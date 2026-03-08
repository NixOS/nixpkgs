{
  lib,
  stdenv,
  stdenvNoCC,
  bun,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  installShellFiles,
  makeDesktopItem,
  makeBinaryWrapper,
  nix-update-script,
  node-gyp,
  nodejs,
  python3,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "t3code";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "pingdotgg";
    repo = "t3code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-66qxVToZxH6AUDWUkA7OCJkrlEe3eBIX1jHghGT1/T0=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) src version;

    strictDeps = true;

    nativeBuildInputs = [
      bun
      nodejs
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    postPatch = ''
      for packageJson in \
        apps/server/package.json \
        apps/web/package.json \
        packages/contracts/package.json \
        packages/shared/package.json
      do
        substituteInPlace "$packageJson" \
          --replace-fail '"prepare": "effect-language-service patch",' '"prepare": "true",'
      done
    '';

    buildPhase = ''
      runHook preBuild

      bun install \
        --ignore-scripts \
        --no-progress \
        --frozen-lockfile \
        --filter ./apps/desktop \
        --filter ./apps/server \
        --filter ./apps/web \
        --filter ./packages/contracts \
        --filter ./packages/shared

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    outputHash = "sha256-nJUgJoT2HNSjzzUDZ2aRhTJFcfTDQvuoQ4F42Fz+/90=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bun
    copyDesktopItems
    installShellFiles
    makeBinaryWrapper
    node-gyp
    nodejs
    python3
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .

    chmod -R u+rwX node_modules
    patchShebangs node_modules

    # Compile node-pty's native addon from the vendored bun store.
    cd node_modules/.bun/node-pty@*/node_modules/node-pty
    node-gyp rebuild
    node scripts/post-install.js
    cd "$NIX_BUILD_TOP/$sourceRoot"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run --cwd apps/web build
    bun run --cwd apps/server build
    bun run --cwd apps/desktop build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/t3code/apps/{desktop,server}
    cp -R --no-preserve=mode node_modules $out/libexec/t3code/
    cp -R --no-preserve=mode apps/server/{node_modules,dist} $out/libexec/t3code/apps/server/
    cp -R --no-preserve=mode apps/desktop/{node_modules,dist-electron} $out/libexec/t3code/apps/desktop/

    find $out/libexec/t3code -xtype l -delete

    makeWrapper ${lib.getExe nodejs} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags "$out/libexec/t3code/apps/server/dist/index.mjs"

    makeWrapper ${lib.getExe electron} $out/bin/t3code-desktop \
      --add-flags "$out/libexec/t3code/apps/desktop/dist-electron/main.js" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -Dm644 assets/prod/black-universal-1024.png \
      $out/share/icons/hicolor/1024x1024/apps/t3code.png

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} --completions bash) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} --completions zsh) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} --completions fish)
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "t3code";
      desktopName = "T3 Code";
      comment = finalAttrs.meta.description;
      exec = "t3code-desktop %U";
      terminal = false;
      icon = "t3code";
      startupWMClass = "t3code";
      categories = [
        "Development"
        "Utility"
      ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "node_modules"
    ];
  };

  meta = {
    description = "Minimal web GUI for coding agents";
    homepage = "https://github.com/pingdotgg/t3code";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      imalison
      qweered
    ];
    mainProgram = "t3code";
  };
})
