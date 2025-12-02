{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  python-dateutil,
  # test dependencies
  dj-database-url,
  freezegun,
  postgresql,
  psycopg2,
  pytest-django,
  pytest-freezegun,
  pytest-lazy-fixture,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "django-postgres-extra";
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SectorLabs";
    repo = "django-postgres-extra";
    rev = "v${version}";
    hash = "sha256-/2qoXZ2f3un2cgJFAGMnQWBraJ7urkb0kHtcKKJsh6w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    python-dateutil
  ];

  nativeCheckInputs = [
    dj-database-url
    freezegun
    postgresql
    psycopg2
    pytest-django
    pytest-freezegun
    pytest-lazy-fixture
    pytestCheckHook
  ];

  preCheck = ''
    # Start Postgres.
    export PGDATA="$NIX_BUILD_TOP/.postgres"
    export PGHOST="$PGDATA/run"
    export DATABASE_URL=postgresql://''${PGHOST//\//%2F}/psqlextra
    initdb -E UTF8
    mkdir -p "$PGDATA/run"
    cat <<EOF >> "$PGDATA/postgresql.conf"
    unix_socket_directories = '$PGDATA/run'
    EOF
    echo "CREATE DATABASE psqlextra" | postgres --single -E postgres
    echo "Starting Postgres at $PGDATA" >&2
    pg_ctl start -w
  '';

  postCheck = ''
    echo "Stopping Postgres at $PGDATA" >&2
    pg_ctl stop -w
  '';

  disabledTests = [
    "test_management_command_partition_auto_confirm"
    "test_management_command_partition_confirm_no"
    "test_management_command_partition_confirm_yes"
    "test_management_command_partition_dry_run"
  ]
  # tests incompatible with django>=5
  ++ lib.optionals (lib.versionAtLeast django.version "5") [
    "test_schema_editor_clone_model_to_schema"
    "test_schema_editor_clone_model_to_schema_custom_constraint_names"
  ]
  # tests incompatible with django>=5.2
  ++ lib.optionals (lib.versionAtLeast django.version "5.2") [
    "test_query_annotate_rename_chain"
  ];

  pythonImportsCheck = [ "psqlextra" ];

  meta = with lib; {
    description = "Bringing all of PostgreSQL's awesomeness to Django";
    homepage = "https://github.com/SectorLabs/django-postgres-extra";
    changelog = "https://github.com/SectorLabs/django-postgres-extra/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
