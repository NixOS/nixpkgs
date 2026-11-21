{
  bun,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs-slim,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  node_modules =
    finalAttrs:
    stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) src version;
      __structuredAttrs = true;
      strictDeps = true;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;
      dontFixup = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install --no-progress --frozen-lockfile --ignore-scripts

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir "$out" && cp --recursive node_modules "$out"
        runHook postInstall
      '';

      outputHash =
        {
          aarch64-darwin = "sha256-zZF4gcH1YL/xYVLBExC4dGSFJRorKC0VnbCFO/9JllU=";
          aarch64-linux = "sha256-S0VsA6QFcGXC1SMyKiFF5AHjcw/jca3YCVfzwSI7WPo=";
          x86_64-linux = "sha256-/LE1TiI4fkZVZPdmuBvVDg1GFF0NDfDcS8QC3U2sN6w=";
        }
        .${stdenv.hostPlatform.system}
          or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet.");

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tscircuit";
  version = "0.0.3012";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tscircuit";
    repo = "tscircuit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lTwLoByvWhEqb1J0a3/rrewTCryO1KSxgUeT1mwwa2k=";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    nodejs-slim
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.passthru.node_modules}/node_modules .
    chmod -R u+w node_modules
    patchShebangs node_modules

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/lib"
    cp --recursive {dist,cli.mjs,globals.d.ts,package.json} "$out/lib"
    # Install the unpatched node_modules, since the CLI never executes their
    # Node.js shebang scripts and patched copies would pull Node.js into the
    # runtime closure next to bun.
    cp --recursive ${finalAttrs.passthru.node_modules}/node_modules "$out/lib"
    # Wrap with bun, not node: the bundled CLI resolves ".tsx" entrypoints via
    # Bun's module loader.  NODE_ENV must stay unset: forcing it to
    # "production" makes React's jsx-dev-runtime empty, and snapshot then dies
    # with "jsxDEV2 is not a function".  The CLI installs project dependencies
    # with bun when it finds bun on PATH and falls back to npm otherwise.
    # TSCI_SKIP_CLI_UPDATE stops "tsci init" from offering to install
    # tscircuit@latest globally.
    makeWrapper ${lib.getExe bun} \
      "$out/bin/tsci" \
      --add-flags "$out/lib/cli.mjs" \
      --set NODE_PATH "$out/lib/node_modules" \
      --set TSCI_SKIP_CLI_UPDATE true \
      --suffix PATH : ${lib.makeBinPath [ bun ]}
    ln --symbolic tsci "$out/bin/tscircuit"

    runHook postInstall
  '';

  # Keep the prebuilt npm binaries in node_modules unmodified
  dontStrip = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  # The CLI creates its config directory under HOME on startup
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.node_modules = node_modules finalAttrs;

  meta = {
    description = "Create real electronics with TypeScript and React";
    longDescription = ''
      tscircuit makes developing electronics like web
      development.  Edit code in your favorite IDE and watch the
      changes create electronics in realtime.  When you're done,
      [export your project and
      manufacture](https://docs.tscircuit.com/guides/understanding-fabrication-files)!
    '';
    homepage = "https://github.com/tscircuit/tscircuit";
    license = lib.licenses.mit;
    # Prebuilt Node-API addons and executables from npm, such as resvg-js,
    # rollup, and esbuild
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tsci";
    inherit (bun.meta) platforms;
  };
})
