{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
  setuptools-scm,
  shapely,
  sqlalchemy,
  pytestCheckHook,
  pytest-benchmark,
  alembic,
  mysqlclient,
  rasterio,
}:

buildPythonPackage rec {
  pname = "geoalchemy2";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geoalchemy";
    repo = "geoalchemy2";
    tag = version;
    hash = "sha256-09AYiFLlPalNDXUf1M+wQAulHMALeTsAJ4VEIJRRDXQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    sqlalchemy
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
    alembic
    mysqlclient
    rasterio
  ]
  ++ optional-dependencies.shapely;

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "geoalchemy2" ];

  optional-dependencies = {
    shapely = [ shapely ];
    # wkb-wkt-converter = [ wkb-wkt-converter ];
  };

  meta = {
    description = "Toolkit for working with spatial databases";
    homepage = "https://geoalchemy-2.readthedocs.io/";
    changelog = "https://github.com/geoalchemy/geoalchemy2/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
