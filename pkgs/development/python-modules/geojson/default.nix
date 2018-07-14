{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "geojson";
  version = "2.4.0";

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "0r9pc8hgnc5hf5rq98vinbrncn08v4kgzdfmfs14rfypvacsmfpj";
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
