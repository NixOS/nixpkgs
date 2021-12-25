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
  version = "0.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d97f85a4ff84341c12b1d7a6fee5ab5e5e942271279684310bb2f507b6ee5c53";
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

  disabledTestPaths = [
    # tests require live postgis database
    "tests/gallery/test_decipher_raster.py"
    "tests/gallery/test_length_at_insert.py"
    "tests/gallery/test_summarystatsagg.py"
    "tests/gallery/test_type_decorator.py"
    "tests/test_functional.py"
  ];

  meta = with lib; {
    description = "Toolkit for working with spatial databases";
    homepage =  "http://geoalchemy.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}
