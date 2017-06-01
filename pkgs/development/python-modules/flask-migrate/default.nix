{ stdenv, buildPythonPackage, fetchPypi, isPy3k, python, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic
}:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.0.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "107x78lkqsnbg92dld3dkagg07jvchp3ib3y0sivc4ipz6n1y7rk";
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
