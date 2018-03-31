{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pretend";
  version = "1.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r5r7ygz9m6d2bklflbl84cqhjkc2q12xgis8268ygjh30g2q3wk";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/alex/pretend;
    license = licenses.bsd3;
  };
}
