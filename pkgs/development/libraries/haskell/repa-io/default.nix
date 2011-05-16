{cabal, bmp, repa, repaBytestring}:

cabal.mkDerivation (self : {
  pname = "repa-io";
  version = "2.0.0.3";
  sha256 = "1p8h2855jv8nnvf9vq2ywrmm9qk9qdqy6yqr4dj9p90kfcqxgw2g";
  propagatedBuildInputs = [bmp repa repaBytestring];
  meta = {
    description = "Read and write Repa arrays in various formats";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

