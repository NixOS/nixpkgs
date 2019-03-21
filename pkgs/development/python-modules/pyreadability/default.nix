{ lib, fetchPypi, buildPythonPackage
, requests, chardet, cssselect, lxml
, pytest
}:

buildPythonPackage rec {
  pname   = "PyReadability";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k6fq416pdmjcdqh6gdxl0y0k8kj1zlpzwp5574xsvsha18p2zpn";
  };

  propagatedBuildInputs = [ requests chardet cssselect lxml ];

  # ModuleNotFoundError: No module named 'tests'
  doCheck = false;

  meta = {
    homepage = https://github.com/hyperlinkapp/python-readability;
    description = "fast python port of arc90's readability tool, updated to match latest readability.js!";
    license = lib.licenses.asl20;
  };

}
