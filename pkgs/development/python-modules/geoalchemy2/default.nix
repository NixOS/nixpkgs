{ lib
, buildPythonPackage
, fetchPypi
, packaging
, setuptools-scm
, shapely
, sqlalchemy
, alembic
, psycopg2
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "geoalchemy2";
  version = "0.13.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "GeoAlchemy2";
    inherit version;
    hash = "sha256-2Fp96qmiMJAXM/dBnWv/VnS4cwZR3hoH8rZCOqSSXQk=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
    shapely
    sqlalchemy
  ];

  nativeCheckInputs = [
    alembic
    psycopg2
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # tests require live postgis database
    "--deselect=tests/test_pickle.py::TestPickle::test_pickle_unpickle"
    "--deselect=tests/gallery/test_specific_compilation.py::test_specific_compilation"
  ];

  disabledTestPaths = [
    # tests require live postgis database
    "tests/gallery/test_decipher_raster.py"
    "tests/gallery/test_length_at_insert.py"
    "tests/gallery/test_summarystatsagg.py"
    "tests/gallery/test_type_decorator.py"
    "tests/test_functional.py"
    "tests/test_functional_postgresql.py"
    "tests/test_alembic_migrations.py"
  ];

  pythonImportsCheck = [
    "geoalchemy2"
  ];

  meta = with lib; {
    description = "Toolkit for working with spatial databases";
    homepage =  "https://geoalchemy-2.readthedocs.io/";
    changelog = "https://github.com/geoalchemy/geoalchemy2/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
