{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "geojson";
  version = "3.0.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6h34JGvesrvyDQdWcgkRiTQU+c7kazNqHogtLNYM+6E=";
  };

  patches = [
    # Support for Python 3.11 patch versions
    # https://github.com/jazzband/geojson/pull/198
    (fetchpatch {
      url = "https://github.com/jazzband/geojson/commit/3b1698a92c6d62b160bd566511fcd7834e3f0537.patch";
      sha256 = "sha256-xSSWq2zvk9LYGkZ6+r2yvqHWBYm17oAFHr+EGLer5fU=";
    })
  ];

  pythonImportsCheck = [ "geojson" ];

  meta = {
    homepage = "https://github.com/jazzband/geojson";
    description = "Python bindings and utilities for GeoJSON";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
