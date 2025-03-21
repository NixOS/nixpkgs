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
}:

# this is a pythonPackage because of the ipython line magics in pgcli.magic
# integrating with ipython-sql
buildPythonPackage rec {
  pname = "pgcli";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DT7ZkW87viRcKDv0hEUwgP8AInqwhWYMbPuw7FPy6eY=";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTests = [
    # requires running postgres
    "test_application_name_in_env"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_application_name_db_uri" ];

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
      dywedir
      SuperSandro2000
    ];
  };
}
