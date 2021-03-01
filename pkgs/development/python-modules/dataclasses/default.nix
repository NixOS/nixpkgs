{ lib, buildPythonPackage, fetchPypi, isPy36 }:

buildPythonPackage rec {
  pname = "dataclasses";
  version = "0.8";

  # backport only works on Python 3.6, and is in the standard library in Python 3.7
  disabled = !isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8479067f342acf957dc82ec415d355ab5edb7e7646b90dc6e2fd1d96ad084c97";
  };

  meta = with lib; {
    description = "An implementation of PEP 557: Data Classes";
    homepage = "https://github.com/ericvsmith/dataclasses";
    license = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
