{ lib, stdenv, buildPythonPackage, fetchPypi, requests-cache }:

buildPythonPackage rec {
  pname = "coinmarketcap";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bk530cmfqri84m9386ydn3f89gq23nxylvnl523gr5589vw54bj";
  };

  propagatedBuildInputs = [ requests-cache ];

  meta = with lib; {
    description = "A python wrapper around the https://coinmarketcap.com API.";
    homepage = https://github.com/barnumbirr/coinmarketcap;
    license = licenses.asl20;
  };
}
