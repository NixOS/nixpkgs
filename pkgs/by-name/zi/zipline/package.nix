{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  yarn-berry,
  pkg-config,
  makeWrapper,
  cacert,
  prisma-engines,
  openssl,
  ffmpeg,
  python3,
  vips,
  nixosTests,
}:

let
  environment = {
    NEXT_TELEMETRY_DISABLED = "1";
    FFMPEG_BIN = lib.getExe ffmpeg;
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines "schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines "query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines "introspection-engine";
    PRISMA_FMT_BINARY = lib.getExe' prisma-engines "prisma-fmt";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zipline";
  version = "3.7.12";

  src = fetchFromGitHub {
    owner = "diced";
    repo = "zipline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i3IGcSxIhy8jmCMsDJGGszYoFsShBfbv7SjTQL1dDM0=";
  };

  patches = [
    # Update prisma to match the version in nixpkgs exactly (currently 6.3.0). To create this patch, change the
    # versions in `package.json`, then run `nix run nixpkgs#yarn-berry -- install --mode update-lockfile`
    # to update `yarn.lock`.
    ./prisma6.patch
  ];

  # we cannot use fetchYarnDeps because that doesn't support yarn 2/berry lockfiles
  yarnOfflineCache = stdenv.mkDerivation {
    pname = "yarn-deps";
    inherit (finalAttrs) version src patches;

    nativeBuildInputs = [ yarn-berry ];

    dontInstall = true;

    YARN_ENABLE_TELEMETRY = "0";
    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    configurePhase = ''
      export HOME="$NIX_BUILD_TOP"
      yarn config set enableGlobalCache false
      yarn config set cacheFolder $out
      yarn config set --json supportedArchitectures.os '[ "linux" ]'
      yarn config set --json supportedArchitectures.cpu '[ "arm64", "x64" ]'
    '';

    buildPhase = ''
      mkdir -p $out
      yarn install --immutable --mode skip-build
    '';

    outputHash = "sha256-c7U/PMlulbjzWx0w4jstgfjeDYPkmfcXIRCDEQxhirA=";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    nodejs
    yarn-berry
    python3
  ];

  buildInputs = [
    vips
    openssl
  ];

  env = {
    YARN_ENABLE_TELEMETRY = "0";
    ZIPLINE_DOCKER_BUILD = "true";
  } // environment;

  configurePhase = ''
    export HOME="$NIX_BUILD_TOP"
    yarn config set enableGlobalCache false
    yarn config set cacheFolder $yarnOfflineCache
  '';

  buildPhase = ''
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}

    yarn install --immutable --immutable-cache
    yarn build
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/zipline}

    cp -r dist public node_modules .next prisma next.config.js mimes.json package.json $out/share/zipline

    mkBin() {
      makeWrapper ${lib.getExe nodejs} "$out/bin/$1" \
        --chdir "$out/share/zipline" \
        --prefix PATH : ${lib.makeBinPath [ openssl ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]} \
        ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") environment
          )
        } \
        --add-flags "--enable-source-maps $2"
    }

    mkBin zipline dist
    for script in dist/scripts/*.js; do
      mkBin "zipline-$(basename $script .js)" "$script"
    done
  '';

  passthru = {
    tests = { inherit (nixosTests) zipline; };
  };

  meta = {
    description = "ShareX/file upload server that is easy to use, packed with features, and with an easy setup";
    changelog = "https://github.com/diced/zipline/releases/tag/v${finalAttrs.version}";
    homepage = "https://zipline.diced.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "zipline";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
