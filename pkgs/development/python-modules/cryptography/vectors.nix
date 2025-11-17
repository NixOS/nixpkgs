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

  patches = [
    # https://github.com/NixOS/nixpkgs/pull/449568
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/pyca/cryptography/commit/5f311c1cbe09ddea6136b0bb737fb7df6df1b923.patch?full_index=1";
      stripLen = 1;
      includes = [ "pyproject.toml" ];
      hash = "sha256-OdHK0OGrvOi3mS0q+v8keDLvKxtgQkDkHQSYnmC/vd4=";
    })
  ];

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
