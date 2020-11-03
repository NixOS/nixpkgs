{ lib, fetchPypi, buildPythonPackage, isPy3k, future }:

buildPythonPackage rec {
  pname = "ECPy";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9635cffb9b6ecf7fd7f72aea1665829ac74a1d272006d0057d45a621aae20228";
  };

  requiredPythonModules = lib.optional (!isPy3k) future;

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Pure Pyhton Elliptic Curve Library";
    homepage = "https://github.com/ubinity/ECPy";
    license = licenses.asl20;
  };
}
