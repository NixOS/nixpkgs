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
  setuptools-scm,
  sshtunnel,
  mock,
  tzlocal,
}:

# this is a pythonPackage because of the ipython line magics in pgcli.magic
# integrating with ipython-sql
buildPythonPackage rec {
  pname = "pgcli";
  version = "4.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vV+NaK8o/WlVGjy0iihJytX2hUqkgCLp2YxiNtEJ7q4=";
  };

  pythonRelaxDeps = [ "click" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

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
    # requires running postgres and postgresqlTestHook does not work
    "test_application_name_in_env"
    "test_init_command_option"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_application_name_db_uri" ];

  meta = {
    description = "Command-line interface for PostgreSQL";
    mainProgram = "pgcli";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "https://pgcli.com";
    changelog = "https://github.com/dbcli/pgcli/raw/v${version}/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      SuperSandro2000
    ];
  };
}
