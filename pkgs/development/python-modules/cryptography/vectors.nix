{
  lib,
  buildPythonPackage,
  cryptography,
  fetchpatch2,
  uv-build,
}:

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (cryptography) version src;
  pyproject = true;

  sourceRoot = "${src.name}/vectors";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.7.19,<0.9.0" "uv_build>=0.7.19,<0.11.0"
  '';

  build-system = [ uv-build ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "cryptography_vectors" ];

  meta = {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    downloadPage = "https://github.com/pyca/cryptography/tree/master/vectors";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
