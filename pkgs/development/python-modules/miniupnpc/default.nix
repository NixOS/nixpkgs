{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "miniupnpc";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ca94zz7sr2x57j218aypxqcwkr23n8js30f3yrvvqbg929nr93y";
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "miniUPnP client";
    homepage = "http://miniupnp.free.fr/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
