{ stdenv, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19rxhva9i5n643vm3d11f8p98jwai2pavysa217p5w5h5cnksnx2";
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
