{ stdenv, buildPythonPackage, fetchPypi, isPy36 }:

buildPythonPackage rec {
  pname = "dataclasses";
  version = "0.7";

  # backport only works on Python 3.6, and is in the standard library in Python 3.7
  disabled = !isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "494a6dcae3b8bcf80848eea2ef64c0cc5cd307ffc263e17cdf42f3e5420808e6";
  };

  meta = with stdenv.lib; {
    description = "An implementation of PEP 557: Data Classes";
    homepage = "https://github.com/ericvsmith/dataclasses";
    license = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
