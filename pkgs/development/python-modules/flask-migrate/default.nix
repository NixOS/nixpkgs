{ stdenv, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00nm76w4xymsiih6hq8y46wp026v7zkzq15cx39hp929ba3z2vx9";
  };

  checkInputs = [ flask_script ] ++ optional isPy3k glibcLocales;
  propagatedBuildInputs = [ flask flask_sqlalchemy alembic ];

  # tests invoke the flask cli which uses click and therefore has py3k encoding troubles
  preCheck = optionalString isPy3k ''
    export LANG="en_US.UTF-8"
  '';

  meta = {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    license = licenses.mit;
    homepage = https://github.com/miguelgrinberg/Flask-Migrate;
  };
}
