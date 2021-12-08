{ lib, buildPythonPackage, fetchFromGitHub
, python-dateutil, requests }:

buildPythonPackage rec {
  pname = "bitcoin-price-api";
  version = "0.0.4";

  src = fetchFromGitHub {
     owner = "dursk";
     repo = "bitcoin-price-api";
     rev = "v0.0.4";
     sha256 = "1fjigd0v9r7hnjdnpyslzy1hh5njjqsbj2k5xy812x0j4pkbyqra";
  };

  propagatedBuildInputs = [ python-dateutil requests ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = "https://github.com/dursk/bitcoin-price-api";
    description = "Price APIs for bitcoin exchanges";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
