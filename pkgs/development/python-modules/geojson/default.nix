{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "geojson";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06ihcb8839zzgk5jcv18kc6nqld4hhj3nk4f3drzcr8n8893v1y8";
  };

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ glibcLocales ];

  meta = {
    homepage = https://github.com/frewsxcv/python-geojson;
    description = "Python bindings and utilities for GeoJSON";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ geistesk ];
  };
}
