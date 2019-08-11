{ lib, buildPythonPackage, fetchPypi, glibcLocales }:

buildPythonPackage rec {
  pname = "geojson";
  version = "2.4.1";

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "12k4g993qqgrhq2mgy5k8rhm5a2s2hbn769rs5fwbc5lwv4bbgxj";
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
