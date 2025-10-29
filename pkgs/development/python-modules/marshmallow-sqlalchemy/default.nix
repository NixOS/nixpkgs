{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  marshmallow,
  packaging,
  sqlalchemy,
  pytest-lazy-fixtures,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "marshmallow-sqlalchemy";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "marshmallow_sqlalchemy";
    inherit version;
    hash = "sha256-ZBAwS/mOwm6jXz+dPO6C5R/Qk8Q0YSrdMqC9zbVmj3w=";
  };

  build-system = [ flit-core ];

  propagatedBuildInputs = [
    marshmallow
    packaging
    sqlalchemy
  ];

  pythonImportsCheck = [ "marshmallow_sqlalchemy" ];

  nativeCheckInputs = [
    pytest-lazy-fixtures
    pytestCheckHook
  ];

  meta = with lib; {
    description = "SQLAlchemy integration with marshmallow";
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    changelog = "https://github.com/marshmallow-code/marshmallow-sqlalchemy/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
