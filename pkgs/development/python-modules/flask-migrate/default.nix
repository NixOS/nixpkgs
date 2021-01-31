{ lib, buildPythonPackage, fetchPypi, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8626af845e6071ef80c70b0dc16d373f761c981f0ad61bb143a529cab649e725";
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
