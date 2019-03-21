{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15qfl3pnw2f11r0z0zhwl56f6pb60ysav8fxmpnz5p80cfwljdik";
  };

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = https://cryptography.io/en/latest/development/test-vectors/;
    # Source: https://github.com/pyca/cryptography/tree/master/vectors;
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ primeos ];
  };
}
