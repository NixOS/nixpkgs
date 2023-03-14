{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "geojson";
  version = "2.5.0";

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1filqm050ixy53kdv81bd4n80vjvfapnmzizy7jg8a6pilv17gfc";
  };

  LC_ALL = "en_US.UTF-8";
  nativeCheckInputs = [ glibcLocales ];

  meta = {
    homepage = "https://github.com/frewsxcv/python-geojson";
    description = "Python bindings and utilities for GeoJSON";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
