{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9cc100ed0924b32173d7de705a82fdf1257cdf60af1952a13f64759307b40931";
  };

  meta = with lib; {
    homepage = "https://github.com/scoder/fastrlock";
    description = "A fast RLock implementation for CPython";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
