{ stdenv, buildPythonPackage, fetchPypi, isPy36 }:

buildPythonPackage rec {
  pname = "dataclasses";
  version = "0.5";

  # backport only works on Python 3.6, and is in the standard library in Python 3.7
  disabled = !isPy36;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07lgn1k56sqpw7yfzv5a6mwshsgaipjawflgyr6lrkryjl64481z";
  };

  meta = with stdenv.lib; {
    description = "An implementation of PEP 557: Data Classes";
    homepage = "https://github.com/ericvsmith/dataclasses";
    license = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
