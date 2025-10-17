{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
  setuptools-scm,
  shapely,
  sqlalchemy,
  alembic,
  pytest-benchmark,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "geoalchemy2";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "geoalchemy";
    repo = "geoalchemy2";
    tag = version;
    hash = "sha256-xQxry/JJTkhsailk12lhu1SkpLlx0By/D35VSw+S/4M=";
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
    alembic
    pytest-benchmark
    pytestCheckHook
  ]
  ++ optional-dependencies.shapely;

  pytestFlags = [ "--benchmark-disable" ];

  disabledTestPaths = [
    # tests require live databases
    "tests/gallery/test_decipher_raster.py"
    "tests/gallery/test_length_at_insert.py"
    "tests/gallery/test_insert_raster.py"
    "tests/gallery/test_orm_mapped_v2.py"
    "tests/gallery/test_specific_compilation.py"
    "tests/gallery/test_summarystatsagg.py"
    "tests/gallery/test_type_decorator.py"
    "tests/test_functional.py"
    "tests/test_functional_postgresql.py"
    "tests/test_functional_mysql.py"
    "tests/test_alembic_migrations.py"
    "tests/test_pickle.py"
  ];

  pythonImportsCheck = [ "geoalchemy2" ];

  optional-dependencies = {
    shapely = [ shapely ];
  };

  meta = with lib; {
    description = "Toolkit for working with spatial databases";
    homepage = "https://geoalchemy-2.readthedocs.io/";
    changelog = "https://github.com/geoalchemy/geoalchemy2/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
