{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "geojson";
  version = "3.0.1";

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-5J35grIE7UgeTBI2xX9Yet9xU3MBz4+vcSCrJ9c8dWg=";
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
