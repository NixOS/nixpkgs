{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  nixosTests,
  nodejs,
  pnpm_10,
  prisma,
  prisma-engines,
  openssl,
  rustPlatform,
  # build variables
  collectApiEndpoint ? "",
  trackerScriptNames ? [ ],
  basePath ? "",
}:
let
  sources = lib.importJSON ./sources.json;
  pnpm = pnpm_10;

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
    version = "6.18.0";
    src = fetchFromGitHub {
      owner = "prisma";
      repo = "prisma-engines";
      rev = version;
      hash = "sha256-p198o8ON5mGPCxK+gE0mW+JVyQlNsCsqwa8D4MNBkpA=";
    };
    cargoHash = "sha256-bNl04GoxLX+B8dPgqWL/VarreBVebjwNDwQjtQcJnsg=";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (old) pname;
      inherit src version;
      hash = cargoHash;
    };
  });
  prisma' = (prisma.override { prisma-engines = prisma-engines'; }).overrideAttrs (old: rec {
    version = "6.18.0";
    src = fetchFromGitHub {
      owner = "prisma";
      repo = "prisma";
      rev = version;
      hash = "sha256-+WRWa59HlHN2CsYZfr/ptdW3iOuOPfDil8sLR5dWRA4=";
    };
    pnpmDeps = old.pnpmDeps.override {
      inherit src version;
      hash = "sha256-Et1UiZO2zyw9FHW0OuYK7AMfhIy5j7Q7GDQjaL6gjyg=";
    };
  });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "umami";
  version = "3.0.1";

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.configHook
  ];

  src = fetchFromGitHub {
    owner = "umami-software";
    repo = "umami";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M2SWsmvXzOe6ob46ntQ8X8/uOx6/Q5On6zSnkv83uj8=";
  };

  # install dev dependencies as well, for rollup
  pnpmInstallFlags = [ "--prod=false" ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      pnpmInstallFlags
      version
      src
      ;
    fetcherVersion = 2;
    hash = "sha256-Gpl57tTV4ML4ukRMzRu8taO75kyzYwa5PyM0jGbrhHI=";
  };

  env.CYPRESS_INSTALL_BINARY = "0";
  env.NODE_ENV = "production";
  env.NEXT_TELEMETRY_DISABLED = "1";

  env.COLLECT_API_ENDPOINT = collectApiEndpoint;
  env.TRACKER_SCRIPT_NAME = lib.concatStringsSep "," trackerScriptNames;
  env.BASE_PATH = basePath;

  # Allow prisma-cli to find prisma-engines without having to download them
  # Only needed at build time for `prisma generate`.
  env.PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines'}/lib/libquery_engine.node";
  env.PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines'}/bin/schema-engine";

  buildPhase = ''
    runHook preBuild

    pnpm build-db-client # prisma generate

    pnpm build-tracker
    pnpm build-app

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    # Skip broken test: https://github.com/umami-software/umami/issues/3773
    pnpm test --testPathIgnorePatterns="src/lib/__tests__/detect.test.ts"

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
      --prefix PATH : ${
        lib.makeBinPath [
          openssl
          nodejs
        ]
      } \
      --chdir $out \
      --run "${lib.getExe prisma'} migrate deploy" \
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
    prisma = prisma';
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
