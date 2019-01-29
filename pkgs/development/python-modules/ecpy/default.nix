{ lib, fetchPypi, buildPythonPackage, isPy3k, future }:

buildPythonPackage rec {
  pname = "ECPy";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8889122d3a8bc1a08b4bda42c073dd22305d770b7876356de806ff91748983bd";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) future;

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = https://github.com/ubinity/ECPy;
    license = licenses.asl20;
  };
}
