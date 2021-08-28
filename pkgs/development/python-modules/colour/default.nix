{ lib, buildPythonPackage, fetchPypi, d2to1 }:

buildPythonPackage rec {
  pname = "colour";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af20120fefd2afede8b001fbef2ea9da70ad7d49fafdb6489025dae8745c3aee";
  };

  buildInputs = [ d2to1 ];

  meta = with lib; {
    description = "Converts and manipulates common color representation (RGB, HSV, web, ...)";
    homepage = "https://github.com/vaab/colour";
    license = licenses.bsd2;
  };
}
