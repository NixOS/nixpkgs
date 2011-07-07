{cabal, deepseq, hashable}:

cabal.mkDerivation (self : {
  pname = "unordered-containers";
  version = "0.1.4.0";
  sha256 = "1v5m92rn2k7knhca91ldzi082hy4z0hp4nm66ihns4vxgslywgb9";
  propagatedBuildInputs = [deepseq hashable];
  meta = {
    description = "Efficient hashing-based container types";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

