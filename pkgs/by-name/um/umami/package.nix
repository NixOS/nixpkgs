{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, yarnConfigHook
, yarnBuildHook
, nodejs
, postgresql
, prisma
, makeWrapper
, openssl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "umami";
  version = "2.15.1";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    postgresql
    prisma
    openssl
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "umami-software";
    repo = "umami";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BYqIGxNJWeJxYV6qZH4nELffl5Yz4pftq30Bvp/tTNw=";
  };

  # srcs = [
  #   (
  #     fetchFromGitHub {
  #       owner = "umami-software";
  #       repo = "umami";
  #       rev = "v${finalAttrs.version}";
  #       hash = "sha256-BYqIGxNJWeJxYV6qZH4nELffl5Yz4pftq30Bvp/tTNw=";
  #     }
  #   )
  #   (fetchurl {
  #     url="https://raw.githubusercontent.com/GitSquared/node-geolite2-redist/master/redist/GeoLite2-City.tar.gz";
  #     hash = "sha256-vBm+ABC+8EIcJv077HvDvKCMGSgo1ZoVGEVCLcRCB0I=";
  #   })
  # ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-fTvFqyU6CGxeFqC0QYT0G+RrwNwJWkTICY1TIk8ZmYE=";
  };

  env.CYPRESS_INSTALL_BINARY = "0";
  env.NODE_ENV = "production";
  env.NEXT_TELEMETRY_DISABLED = "1";

  # copy-db-files uses this variable, but doesn't connect to the DB
  env.DATABASE_URL = "postgres:dummy";

  buildPhase = ''
    runHook preBuild

    yarn --offline copy-db-files
    # yarn --offline build-db-client
    prisma generate

    yarn --offline build-tracker
    # TODO
    # yarn --offline build-geo
    yarn --offline build-app

    runHook postBuild
  '';

  installPhase = ''

    mv .next/standalone $out

    cp -R public $out/public

    mv .next/static $out/.next/static

    cp next.config.js $out

    cp -R prisma $out/prisma
    cp -R scripts $out/scripts

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/umami-server  \
      --set NODE_ENV production \
      --add-flags "$out/server.js"
  '';

  meta = with lib; {
    description = "simple, easy to use, self-hosted web analytics solution";
    homepage = "https://umami.is/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
})
