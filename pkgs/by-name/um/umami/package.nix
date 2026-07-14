{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  inter,
  makeWrapper,
  nixosTests,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_10,
  prisma_7,
  prisma-engines_7,
  openssl,
  rustPlatform,
  # build variables
  collectApiEndpoint ? "",
  trackerScriptNames ? [ ],
  basePath ? "",
}:
let
  pnpm = pnpm_10;

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
  prisma-engines' = prisma-engines_7.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "7.8.0";
      src = fetchFromGitHub {
        owner = "prisma";
        repo = "prisma-engines";
        tag = finalAttrs.version;
        hash = "sha256-nquIcOmFz+ikD0x/YEPZ5NVKCFPCdR5MSCHldn+b9jI=";
      };
      cargoHash = "sha256-uiFvzxwVJXCW9LUDFRC6ZkzSa7LQk+9ZJcaJw8mrBX4=";

      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (prevAttrs) pname;
        inherit (finalAttrs) src version;
        patches = prevAttrs.cargoDeps.vendorStaging.patches or [ ];
        hash = finalAttrs.cargoHash;
      };
    }
  );
  prisma' = (prisma_7.override { prisma-engines_7 = prisma-engines'; }).overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "7.8.0";
      src = fetchFromGitHub {
        owner = "prisma";
        repo = "prisma";
        tag = finalAttrs.version;
        hash = "sha256-89q5433z54h3oGX+lEYDQykN2mNltGz4+LWlYSE75/E=";
      };
      pnpmDeps = prevAttrs.pnpmDeps.override {
        inherit (finalAttrs) src version;
        hash = "sha256-mrFU5SAF4QuTBJj5TP8tUkYDG4zchttjcQMLtx6OBnI=";
      };
    }
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "umami";
  version = "3.2.0";

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpmBuildHook
    pnpm
  ];

  src = fetchFromGitHub {
    owner = "umami-software";
    repo = "umami";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0nfCcaST06cTg43Rz1rCV8GYYDjQLP+6TrVRJF2/Yuk=";
  };

  # Umami uses next/font/google, which tries to download from Google Fonts at build time.
  # Replace that code with a copy of the required font(s) from nixpkgs instead.
  postPatch = ''
    substituteInPlace ./src/app/layout.tsx \
      --replace-fail "import { Inter } from 'next/font/google';" "import localFont from 'next/font/local';" \
      --replace-fail 'const inter = Inter({' "const inter = localFont({ src: './Inter.ttf',"

    cp "${inter}/share/fonts/truetype/InterVariable.ttf" src/app/Inter.ttf
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-6ho5xoVdqZdihThL5q8+RhVPfaSwu1y3+p9d8DnfO3o=";
  };

  env.NODE_ENV = "production";
  env.NEXT_TELEMETRY_DISABLED = "1";

  env.COLLECT_API_ENDPOINT = collectApiEndpoint;
  env.TRACKER_SCRIPT_NAME = lib.concatStringsSep "," trackerScriptNames;
  env.BASE_PATH = basePath;

  # Needs to be non-empty during build
  env.DATABASE_URL = "postgresql://";
  # No DB is available during build
  env.SKIP_DB_CHECK = "1";

  # Geocities is handled manually
  env.SKIP_BUILD_GEO = "1";

  # Allow prisma-cli to find prisma-engines without having to download them
  # Only needed at build time for `prisma generate`.
  env.PRISMA_QUERY_ENGINE_LIBRARY = "${finalAttrs.passthru.prisma-engines}/lib/libquery_engine.node";
  env.PRISMA_SCHEMA_ENGINE_BINARY = "${finalAttrs.passthru.prisma-engines}/bin/schema-engine";

  checkPhase = ''
    runHook preCheck

    # Tests fail if NODE_ENV=production
    NODE_ENV=development pnpm test

    runHook postCheck
  '';

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mv .next/standalone $out
    mv .next/static $out/.next/static

    cp -R public $out/public
    cp -R prisma $out/prisma
    cp prisma.config.ts $out/prisma.config.ts
    substituteInPlace $out/prisma.config.ts \
      --replace-fail "import 'dotenv/config';" "" \
      --replace-fail "from 'prisma/config';" "from '${finalAttrs.passthru.prisma}/lib/prisma/packages/config';"

    mkdir -p $out/bin
    # Run database migrations before starting umami.
    # Add openssl to PATH since it is required for prisma to make SSL connections.
    # Force working directory to $out because umami assumes many paths are relative to it (e.g., prisma and geolite).
    makeWrapper ${nodejs}/bin/node $out/bin/umami-server  \
      --set NODE_ENV production \
      --set NEXT_TELEMETRY_DISABLED 1 \
      --set GEOLITE_DB_PATH ${lib.escapeShellArg "${finalAttrs.passthru.geocities}/GeoLite2-City.mmdb"} \
      --prefix PATH : ${
        lib.makeBinPath [
          openssl
          nodejs
        ]
      } \
      --chdir $out \
      --run "${lib.getExe finalAttrs.passthru.prisma} migrate deploy" \
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

  meta = {
    changelog = "https://github.com/umami-software/umami/releases/tag/v${finalAttrs.version}";
    description = "Simple, easy to use, self-hosted web analytics solution";
    homepage = "https://umami.is/";
    license = with lib.licenses; [
      mit
      cc-by-40 # geocities
    ];
    platforms = lib.platforms.linux;
    mainProgram = "umami-server";
    maintainers = with lib.maintainers; [ diogotcorreia ];
  };
})
