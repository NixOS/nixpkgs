{
  lib,
  buildPythonPackage,
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
  version = "1.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "marshmallow_sqlalchemy";
    inherit version;
    hash = "sha256-5RGSwgR3BkWi+rDXL0T4eJJy7vdZUfhLFgjWtLC/4OY=";
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

  meta = {
    description = "SQLAlchemy integration with marshmallow";
    homepage = "https://github.com/marshmallow-code/marshmallow-sqlalchemy";
    changelog = "https://github.com/marshmallow-code/marshmallow-sqlalchemy/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
