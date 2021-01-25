{ lib, stdenv, buildPythonPackage, fetchPypi, coincurve, requests, cashaddress-regtest, click }:

buildPythonPackage rec {
  pname = "bitcash";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09i6fvjc2mrz4s956pcjrrb5xab8wf542pirybzf6wbh4n57kisq";
  };

  propagatedBuildInputs = [ coincurve requests cashaddress-regtest ];

  checkInputs = [ click ];

  meta = with lib; {
    description = "Python 3 Bitcoin Cash Library";
    homepage = "https://github.com/pybitcash/bitcash";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
}
