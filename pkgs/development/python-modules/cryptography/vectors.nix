{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  uv-build,
}:

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (cryptography) version;
  pyproject = true;

  src = fetchPypi {
    pname = "cryptography_vectors";
    inherit version;
    hash = "sha256-B40Sh84rRdJGtCxs+545Dh96+hdsGZsL1t6p1s6Jou4=";
  };

  build-system = [ uv-build ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "cryptography_vectors" ];

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    downloadPage = "https://github.com/pyca/cryptography/tree/master/vectors";
    license = with licenses; [
      asl20
      bsd3
    ];
    maintainers = with maintainers; [ mdaniels5757 ];
  };
}
