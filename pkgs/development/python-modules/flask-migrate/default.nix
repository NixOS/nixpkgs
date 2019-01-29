{ stdenv, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1awlb4q1l9iv794qjjxxyhcv4i69j77kh7nsg17a6kb909mglml3";
  };

  checkInputs = optional isPy3k glibcLocales;
  propagatedBuildInputs = [ flask flask_sqlalchemy flask_script alembic ];

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
