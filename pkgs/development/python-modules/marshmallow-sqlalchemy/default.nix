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
  version = "0.25.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i39ckrixh1w9fmkm0wl868gvza72j5la0x6dd0cij9shf1iyjgi";
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
