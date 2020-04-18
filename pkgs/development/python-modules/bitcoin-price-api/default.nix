{ lib, buildPythonPackage, fetchPypi
, dateutil, requests }:

buildPythonPackage rec {
  pname = "bitcoin-price-api";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc68076f9632aaa9a8009d916d67a709c1e045dd904cfc7a3e8be33960d32029";
  };

  propagatedBuildInputs = [ dateutil requests ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = "https://github.com/dursk/bitcoin-price-api";
    description = "Price APIs for bitcoin exchanges";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
