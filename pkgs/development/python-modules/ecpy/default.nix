{ lib, fetchPypi, buildPythonPackage, isPy3k, future }:

buildPythonPackage rec {
  pname = "ECPy";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6dd09f8cda5a1d673228ff9ef41aea8f036ee5ef3183198de83c14957d68c3e0";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) future;

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = "https://github.com/ubinity/ECPy";
    license = licenses.asl20;
  };
}
