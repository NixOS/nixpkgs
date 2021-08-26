{ lib, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57d6060839e3a7f150eaab6fe4e726d9e3e7cffe2150fb223d73f92421c6d1d9";
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
