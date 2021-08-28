{ lib, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae2f05671588762dd83a21d8b18c51fe355e86783e24594995ff8d7380dffe38";
  };

  checkInputs = [ flask_script ] ++ lib.optional isPy3k glibcLocales;
  propagatedBuildInputs = [ flask flask_sqlalchemy alembic ];

  # tests invoke the flask cli which uses click and therefore has py3k encoding troubles
  preCheck = lib.optionalString isPy3k ''
    export LANG="en_US.UTF-8"
  '';

  meta = with lib; {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    license = licenses.mit;
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
  };
}
