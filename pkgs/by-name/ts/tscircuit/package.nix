{
  bun,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  node-gyp,
  nodejs,
  pkg-config,
  python3Minimal,
  stdenv,
  versionCheckHook,
  vips,
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
          aarch64-darwin = lib.fakeHash;
          aarch64-linux = lib.fakeHash;
          x86_64-linux = "sha256-xnVwWdxnsoV33StWT9RwfqyEYeBtU0SQJQiR9AttFoY=";
        }
        .${stdenv.hostPlatform.system}
          or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet.");

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tscircuit";
  version = "0.0.2462";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tscircuit";
    repo = "tscircuit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UtYp1JgD1ybwfXvL6lxpfM4Ff3nhY4LMS9OpiSArnfc=";
  };

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
    node-gyp
    nodejs
    pkg-config
    python3Minimal
    writableTmpDirAsHomeHook
  ];

  buildInputs = [ vips ];

  env = {
    NODE_PATH = "${lib.getLib node-gyp}/node_modules";
    npm_config_nodedir = nodejs;
  };

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.passthru.node_modules}/node_modules .
    chmod -R u+w node_modules
    patchShebangs node_modules

    # Force sharp to build its native binding against the system libvips.
    (cd node_modules/sharp && node install/libvips && node install/dll-copy && prebuild-install) || \
    (cd node_modules/sharp && node install/can-compile && node-gyp rebuild && node install/dll-copy)

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/lib"
    cp --recursive {dist,node_modules,cli.mjs,package.json} "$_"
    # Wrap with bun, not node: the bundled CLI resolves ".tsx" entrypoints via
    # Bun's module loader.  NODE_ENV must stay unset: forcing it to
    # "production" makes React's jsx-dev-runtime empty, and snapshot then dies
    # with "jsxDEV2 is not a function".
    makeWrapper ${lib.getExe bun} \
      "$out/bin/${finalAttrs.meta.mainProgram}" \
      --add-flags "$out/lib/cli.mjs" \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.node_modules = node_modules finalAttrs;

  meta = {
    description = "Create real electronics with Typescript and React";
    longDescription = ''
      tscircuit makes developing electronics like web
      development. Edit code in your favorite IDE and watch the
      changes create electronics in realtime. When you're done,
      [export your project and
      manufacture](https://docs.tscircuit.com/guides/understanding-fabrication-files)!
    '';
    homepage = "https://github.com/tscircuit/tscircuit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tsci";
    inherit (bun.meta) platforms;
  };
})
