{ lib
, buildPythonPackage
, fetchPypi
, packaging
, setuptools-scm
, shapely
, sqlalchemy
, psycopg2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.11.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+SoPrdtbdDhNu/PHAAQzNYzo4HoYD+HWwoQ+qgQ3/wg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
    shapely
    sqlalchemy
  ];

  checkInputs = [
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
  ];

  pythonImportsCheck = [
    "geoalchemy2"
  ];

  meta = with lib; {
    description = "Toolkit for working with spatial databases";
    homepage =  "http://geoalchemy.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}
