{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs_24,
  makeWrapper,
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
  };

  pnpm' = pnpm_10.override { nodejs-slim = nodejs_24; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zipline";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "diced";
    repo = "zipline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwkK69Tp03MNA08kk6BZhmso2iEHNqh7Imn8a3hG5fg=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git_head
      rm -rf $out/.git
    '';
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm';
    fetcherVersion = 3;
    hash = "sha256-Qoz7g9ekYBm4qFkp6X1251BY9AtIZWgcOBO13bXtCcw=";
  };

  buildInputs = [
    openssl
    vips
  ];

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm'
    nodejs_24
    makeWrapper
    # for sharp build:
    node-gyp
    pkg-config
    python3
  ];

  env = environment // {
    DATABASE_URL = "dummy";
    NODE_PATH = "${node-gyp}/lib/node_modules";
  };

  buildPhase = ''
    runHook preBuild

    # Force build of sharp against native libvips (requires running install scripts).
    # This is necessary for supporting old CPUs (ie. without SSE 4.2 instruction set).
    pnpm config set nodedir ${nodejs_24}
    npm explore sharp -- pnpm run build

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    CI=true pnpm prune --prod
    find node_modules -xtype l -delete

    mkdir -p $out/{bin,share/zipline}

    cp -r build drizzle node_modules mimes.json code.json package.json $out/share/zipline

    mkBin() {
      makeWrapper ${lib.getExe nodejs_24} "$out/bin/$1" \
        --chdir "$out/share/zipline" \
        --set NODE_ENV production \
        --set ZIPLINE_GIT_SHA "$(<$src/.git_head)" \
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
  versionCheckKeepEnvironment = [ "DATABASE_URL" ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) zipline; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ShareX/file upload server that is easy to use, packed with features, and with an easy setup";
    homepage = "https://zipline.diced.sh/";
    downloadPage = "https://github.com/diced/zipline";
    changelog = "https://github.com/diced/zipline/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "zipline";
    platforms = lib.platforms.linux;
  };
})
