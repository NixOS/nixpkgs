{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "macpack";
  version = "1.0.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xa1ybrkjkbymjw0wrk9x2w03jck5z3330f5ns1g29hlv5yr7h83";
  };

  meta = {
    description = "A utility that makes a macOS binary redistributable";
    license = stdenv.lib.licenses.mit;
    homepage = https://github.com/chearon/macpack;
  };

}
