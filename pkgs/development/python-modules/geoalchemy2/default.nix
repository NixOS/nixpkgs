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
  version = "0.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b51f4d0558b7effb9add93aaa813c7a160ed293c346f5379a6fa1c8049af062";
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
