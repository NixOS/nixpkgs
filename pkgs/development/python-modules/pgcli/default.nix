{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  cli-helpers,
  click,
  configobj,
  prompt-toolkit,
  psycopg,
  pygments,
  sqlparse,
  pgspecial,
  setproctitle,
  keyring,
  pendulum,
  pytestCheckHook,
  setuptools,
  sshtunnel,
  mock,
  tzlocal,
}:

# this is a pythonPackage because of the ipython line magics in pgcli.magic
# integrating with ipython-sql
buildPythonPackage rec {
  pname = "pgcli";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dlrhVQxVCKSB8Z8WqZcWwlP+ka+yVXl63S1jXaILau8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cli-helpers
    click
    configobj
    prompt-toolkit
    psycopg
    pygments
    sqlparse
    pgspecial
    setproctitle
    keyring
    pendulum
    sshtunnel
    tzlocal
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTests = [
    # requires running postgres
    "test_application_name_in_env"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_application_name_db_uri" ];

  meta = with lib; {
    description = "Command-line interface for PostgreSQL";
    mainProgram = "pgcli";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "https://pgcli.com";
    changelog = "https://github.com/dbcli/pgcli/raw/v${version}/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      SuperSandro2000
    ];
  };
}
