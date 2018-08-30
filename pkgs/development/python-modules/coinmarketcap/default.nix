{ lib, buildPythonPackage, fetchPypi, requests-cache }:

buildPythonPackage rec {
  pname = "coinmarketcap";
  version = "5.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cfee31bf330a17cedf188e4e99588e6a4c6c969c93da71f55a9f4ec6a6c216f";
  };

  propagatedBuildInputs = [ requests-cache ];

  meta = with lib; {
    description = "A python wrapper around the https://coinmarketcap.com API.";
    homepage = https://github.com/barnumbirr/coinmarketcap;
    license = licenses.asl20;
  };
}
