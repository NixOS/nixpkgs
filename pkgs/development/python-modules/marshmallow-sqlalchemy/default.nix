{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, marshmallow
, packaging
, sqlalchemy
, pytest-lazy-fixture
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "0.30.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ka0KT9G0oeUtywf5Zz0oSmsHlRQZFswhadTuml0Ac0c=";
  };

  propagatedBuildInputs = [
    marshmallow
    packaging
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
    description = "SQLAlchemy integration with marshmallow";
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    changelog = "https://github.com/marshmallow-code/marshmallow-sqlalchemy/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
