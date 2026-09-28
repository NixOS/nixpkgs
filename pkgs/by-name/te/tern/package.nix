{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  postgresql,
  postgresqlTestHook,
}:

buildGoModule (finalAttrs: {
  pname = "tern";
  version = "2.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jackc";
    repo = "tern";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K76TowSW1bdyqVoZdlnqXV2Jlk9exMS2D/keE/9buFc=";
  };

  vendorHash = "sha256-rUPJTwGdZABZxEjON7JeB38GDpV+KN7VfbNyU//SadM=";

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  # Tests drop/recreate the database via dropdb/createdb
  postgresqlTestUserOptions = "LOGIN CREATEDB";

  # Sets variables read by tests that are normally set by tern's
  # scripts/dev-env.bash
  postgresqlTestSetupPost = ''
    # tern uses a separate database for the migration tests, because go test
    # runs the root and migrate package tests in parallel, and the migrate
    # tests drop/recreate their database
    export MIGRATE_TEST_DATABASE=test_db_migrate
    createdb "$MIGRATE_TEST_DATABASE"
    export MIGRATE_TEST_CONN_STRING="host=$PGHOST user=$PGUSER database=$MIGRATE_TEST_DATABASE sslmode=disable"

    export TERN_TEST_CONFIG=$NIX_BUILD_TOP/tern-test.conf
    export TERN_TEST_CONN_STRING="host=$PGHOST user=$PGUSER database=$PGDATABASE sslmode=disable"
    cat << EOF > "$TERN_TEST_CONFIG"
    [database]
    host = $PGHOST
    user = $PGUSER
    database = $PGDATABASE
    sslmode = disable
    EOF
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Standalone PostgreSQL database migration tool";
    homepage = "https://github.com/jackc/tern";
    changelog = "https://github.com/jackc/tern/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lajdre ];
    mainProgram = "tern";
  };
})
