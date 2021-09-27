{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "rangehttpserver";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18m79vh693ahd8z3x34naifflz675wyqnlrmiz9630acs0ha8iyf";
  };

  # Tests never complete.
  doCheck = false;

  meta = with lib; {
    description = "SimpleHTTPServer with support for Range requests";
    homepage = "https://github.com/danvk/RangeHTTPServer";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ ajgrf ];
  };
}
