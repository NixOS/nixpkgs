{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  nodejs_24,
  makeWrapper,
  prisma-engines,
  ffmpeg,
  openssl,
  vips,
  versionCheckHook,
  nix-update-script,
  nixosTests,
  node-gyp,
  pkg-config,
  python3,
}:

let
  environment = {
    NEXT_TELEMETRY_DISABLED = "1";
    FFMPEG_PATH = lib.getExe ffmpeg;
    FFPROBE_PATH = lib.getExe' ffmpeg "ffprobe";
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines "schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines "query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines "introspection-engine";
    PRISMA_FMT_BINARY = lib.getExe' prisma-engines "prisma-fmt";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zipline";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "diced";
    repo = "zipline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zm2xNhWghg/Pa9LhLzV+AG/tfiSjAiSnGs8OMnC0Tpw=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-kIneqtLPZ29PzluKUGO4XbQYHbNddu0kTfoP4C22k7U=";
  };

  buildInputs = [
    openssl
    vips
  ];

  nativeBuildInputs = [
    pnpm_10.configHook
    nodejs_24
    makeWrapper
    # for sharp build:
    node-gyp
    pkg-config
    python3
  ];

  env = environment;

  buildPhase = ''
    runHook preBuild

    # Force build of sharp against native libvips (requires running install scripts).
    # This is necessary for supporting old CPUs (ie. without SSE 4.2 instruction set).
    pnpm config set nodedir ${nodejs_24}
    pnpm install --force --offline --frozen-lockfile

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/zipline}

    cp -r build generated node_modules prisma .next mimes.json code.json package.json $out/share/zipline

    mkBin() {
      makeWrapper ${lib.getExe nodejs_24} "$out/bin/$1" \
        --chdir "$out/share/zipline" \
        --set NODE_ENV production \
        --prefix PATH : ${lib.makeBinPath [ openssl ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]} \
        ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") environment
          )
        } \
        --add-flags "--enable-source-maps build/$2"
    }

    mkBin zipline server
    mkBin ziplinectl ctl

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/ziplinectl";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    inherit prisma-engines;
    tests = { inherit (nixosTests) zipline; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ShareX/file upload server that is easy to use, packed with features, and with an easy setup";
    changelog = "https://github.com/diced/zipline/releases/tag/v${finalAttrs.version}";
    homepage = "https://zipline.diced.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "zipline";
    platforms = lib.platforms.linux;
  };
})
