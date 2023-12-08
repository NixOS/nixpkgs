{ stdenv, lib, buildPythonPackage, fetchPypi, cctools, which }:

buildPythonPackage rec {
  pname = "miniupnpc";
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ca94zz7sr2x57j218aypxqcwkr23n8js30f3yrvvqbg929nr93y";
  };

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ cctools which ];

  meta = with lib; {
    description = "miniUPnP client";
    homepage = "http://miniupnp.free.fr/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
