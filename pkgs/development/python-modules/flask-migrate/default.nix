{ stdenv, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a69d508c2e09d289f6e55a417b3b8c7bfe70e640f53d2d9deb0d056a384f37ee";
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
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
  };
}
