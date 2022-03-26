{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, marshmallow
, sqlalchemy
, pytest-lazy-fixture
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "0.27.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1521b129564444648c523a38f6446c137f1aae5c9c7de1ec151d5ebf03fd407d";
  };

  propagatedBuildInputs = [
    marshmallow
    sqlalchemy
  ];

  pythonImportsCheck = [
    "marshmallow_sqlalchemy"
  ];

  checkInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    description = "SQLAlchemy integration with marshmallow";
    license = licenses.mit;
  };

}
