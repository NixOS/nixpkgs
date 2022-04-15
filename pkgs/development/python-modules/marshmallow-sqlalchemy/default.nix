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
  version = "0.28.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+2sGaG84/sLqDsU6XuSXkhlAnisiYPm8keS0MQXRl4I=";
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
