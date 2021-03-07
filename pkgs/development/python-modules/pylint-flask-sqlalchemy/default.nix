{ buildPythonPackage
, fetchPypi
, isPy3k
, lib
, pytestCheckHook
, pylint-plugin-utils
, flask_sqlalchemy
}:

buildPythonPackage rec {
  pname = "pylint-flask-sqlalchemy";
  version = "0.2.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "pylint_flask_sqlalchemy";
    sha256 = "10dam2dm5kvz2wjbsi7zzrm7m7c8y3y3yf6q76xdhrd4l6mmpplf";
  };

  propagatedBuildInputs = [
    pylint-plugin-utils
    flask_sqlalchemy
  ];

  doCheck = false; # Tests are unfortunately broken

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pylint plugin for improving code analysis when editing code using Flask-SQLAlchemy";
    homepage = "https://gitlab.anybox.cloud/rboyer/pylint_flask_sqlalchemy";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nomisiv ];
  };
}
