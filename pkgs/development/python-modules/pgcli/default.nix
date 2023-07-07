{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, cli-helpers
, click
, configobj
, prompt-toolkit
, psycopg
, pygments
, sqlparse
, pgspecial
, setproctitle
, keyring
, pendulum
, pytestCheckHook
, sshtunnel
, mock
}:

# this is a pythonPackage because of the ipython line magics in pgcli.magic
# integrating with ipython-sql
buildPythonPackage rec {
  pname = "pgcli";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zESNlRWfwJA9NhgpkneKCW7aV1LWYNR2cTg8jiv2M/E=";
  };

  propagatedBuildInputs = [
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

  nativeCheckInputs = [ pytestCheckHook mock ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_application_name_db_uri" ];

  meta = with lib; {
    description = "Command-line interface for PostgreSQL";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "https://pgcli.com";
    changelog = "https://github.com/dbcli/pgcli/raw/v${version}/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dywedir SuperSandro2000 ];
  };
}
