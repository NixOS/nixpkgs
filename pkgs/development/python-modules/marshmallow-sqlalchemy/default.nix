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
  version = "0.28.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qjdnRylngKVjVeMGe5yL9DoqHET/mF3oKzpdnhYcorg=";
  };

  propagatedBuildInputs = [
    marshmallow
    sqlalchemy
  ];

  pythonImportsCheck = [
    "marshmallow_sqlalchemy"
  ];

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    description = "SQLAlchemy integration with marshmallow";
    license = licenses.mit;
  };

}
