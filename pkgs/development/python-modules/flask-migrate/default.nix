{ stdenv, buildPythonPackage, fetchPypi, isPy3k, python, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic
}:

with stdenv.lib;

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "716d5b68eec53821f80b3fbcb0fd60baed0cb0e320abb30289e83217668cef7f";
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
