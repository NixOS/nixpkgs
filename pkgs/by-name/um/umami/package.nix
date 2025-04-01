{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  fetchYarnDeps,
  makeWrapper,
  nixosTests,
  nodejs,
  prisma-engines,
  openssl,
  rustPlatform,
  yarnConfigHook,
  yarnBuildHook,
  # build variables
  databaseType ? "postgresql",
  collectApiEndpoint ? "",
  trackerScriptNames ? [ ],
}:
let
  sources = lib.importJSON ./sources.json;

  geocities = stdenvNoCC.mkDerivation {
    pname = "umami-geocities";
    version = sources.geocities.date;
    src = fetchurl {
      url = "https://raw.githubusercontent.com/GitSquared/node-geolite2-redist/${sources.geocities.rev}/redist/GeoLite2-City.tar.gz";
      inherit (sources.geocities) hash;
    };

    doBuild = false;

    installPhase = ''
      mkdir -p $out
      cp ./GeoLite2-City.mmdb $out/GeoLite2-City.mmdb
    '';

    meta.license = lib.licenses.cc-by-40;
  };

  # Pin the specific version of prisma to the one used by upstream
  # to guarantee compatibility.
  prisma-engines' = prisma-engines.overrideAttrs (old: rec {
    version = "6.1.0";
    src = fetchFromGitHub {
      owner = "prisma";
      repo = "prisma-engines";
      tag = version;
      hash = "sha256-BQwT1wXvwyXoPX/oQ8MmaJZlXZpvhdV9QSlGOSAUy/Q=";
    };
    cargoHash = "sha256-1TtJwZCsVhEYKn5SDK7pe0mge8uNSjNl4l+7SIrFXIk=";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (old) pname;
      inherit src version;
      hash = cargoHash;
    };
  });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "umami";
  inherit (sources) version;

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "umami-software";
    repo = "umami";
    tag = "v${finalAttrs.version}";
    inherit (sources) hash;
  };

  patches = [
    # Include prisma cli in next standalone build.
    # This is preferred to using the prisma in nixpkgs because it guarantees
    # the version matches.
    # See https://nextjs-forum.com/post/1280550687998083198
    # and https://nextjs.org/docs/pages/api-reference/config/next-config-js/output#caveats
    ./0001-include-prisma-cli-in-build.diff
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = sources.yarnHash;
  };

  env.CYPRESS_INSTALL_BINARY = "0";
  env.NODE_ENV = "production";
  env.NEXT_TELEMETRY_DISABLED = "1";

  # copy-db-files uses this variable to decide which Prisma schema to use
  env.DATABASE_TYPE = databaseType;

  env.COLLECT_API_ENDPOINT = collectApiEndpoint;
  env.TRACKER_SCRIPT_NAME = lib.concatStringsSep "," trackerScriptNames;

  # Allow prisma-cli to find prisma-engines without having to download them
  env.PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines'}/lib/libquery_engine.node";
  env.PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines'}/bin/schema-engine";

  buildPhase = ''
    runHook preBuild

    yarn --offline copy-db-files
    yarn --offline build-db-client # prisma generate

    yarn --offline build-tracker
    yarn --offline build-app

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    yarn --offline test

    runHook postCheck
  '';

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mv .next/standalone $out
    mv .next/static $out/.next/static

    cp -R public $out/public
    cp -R prisma $out/prisma

    ln -s ${geocities} $out/geo

    mkdir -p $out/bin
    # Run database migrations before starting umami.
    # Add openssl to PATH since it is required for prisma to make SSL connections.
    # Force working directory to $out because umami assumes many paths are relative to it (e.g., prisma and geolite).
    makeWrapper ${nodejs}/bin/node $out/bin/umami-server  \
      --set NODE_ENV production \
      --set NEXT_TELEMETRY_DISABLED 1 \
      --set PRISMA_QUERY_ENGINE_LIBRARY "${prisma-engines'}/lib/libquery_engine.node" \
      --set PRISMA_SCHEMA_ENGINE_BINARY "${prisma-engines'}/bin/schema-engine" \
      --prefix PATH : ${lib.makeBinPath [ openssl ]} \
      --chdir $out \
      --run "$out/node_modules/.bin/prisma migrate deploy" \
      --add-flags "$out/server.js"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) umami;
    };
    inherit
      sources
      geocities
      ;
    prisma-engines = prisma-engines';
    updateScript = ./update.sh;
  };

  meta = with lib; {
    changelog = "https://github.com/umami-software/umami/releases/tag/v${finalAttrs.version}";
    description = "Simple, easy to use, self-hosted web analytics solution";
    homepage = "https://umami.is/";
    license = with lib.licenses; [
      mit
      cc-by-40 # geocities
    ];
    platforms = lib.platforms.linux;
    mainProgram = "umami-server";
    maintainers = with maintainers; [ diogotcorreia ];
  };
})
