{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  writeShellScript,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  npmHooks,
  withPostgresql ? true,
  postgresql,
  prisma,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "umami";
  version = "2.15.1";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    npmHooks.npmInstallHook
    postgresql
    prisma
    openssl
  ];

  src = fetchFromGitHub {
    owner = "mikecao";
    repo = "umami";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BYqIGxNJWeJxYV6qZH4nELffl5Yz4pftq30Bvp/tTNw=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-fTvFqyU6CGxeFqC0QYT0G+RrwNwJWkTICY1TIk8ZmYE=";
  };

  env.CYPRESS_INSTALL_BINARY = "0";
  env.NODE_ENV = "production";

  preBuild = ''
    cp -r db/postgresql prisma
    prisma generate
    echo "" > scripts/copy-db-files.js # doesn't work?

    initdb -A trust $NIX_BUILD_TOP/postgres >/dev/null
    postgres -D $NIX_BUILD_TOP/postgres -k $NIX_BUILD_TOP >/dev/null &
    export PGHOST=$NIX_BUILD_TOP

    echo "Waiting for PostgreSQL to be ready.."
    while ! psql -l >/dev/null; do
      sleep 0.1
    done

    psql -d postgres -tAc 'CREATE USER "umami"'
    psql -d postgres -tAc 'CREATE DATABASE "umami" OWNER "umami"'
    psql 'umami' -tAc "CREATE EXTENSION IF NOT EXISTS pg_trgm"
    psql 'umami' -tAc "CREATE EXTENSION IF NOT EXISTS hstore"

    # Create a temporary home dir to stop bundler from complaining
    mkdir $NIX_BUILD_TOP/tmp_home
    export HOME=$NIX_BUILD_TOP/tmp_home

    # populate DATABASE_URL
    export DATABASE_URL="postgres://umami:umami@$NIX_BUILD_TOP"
  '';

  postInstall =
    let
      run-script = writeShellScript "run" ''
        npm run start-docker
      '';
    in
    ''
      makeWrapper ${run-script} $out/run-umami --set NODE_ENV production
    '';

  meta = with lib; {
    description = "simple, easy to use, self-hosted web analytics solution";
    homepage = "https://umami.is/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
})
