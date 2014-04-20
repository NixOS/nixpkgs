{ cabal }:

cabal.mkDerivation (self: {
  pname = "primitive";
  version = "0.5.2.1";
  sha256 = "1vn3y5gh4lwvgvklhn8k1z7gxjy27ik621f4gpa9cb7gqa0nnl8f";
  meta = {
    homepage = "https://github.com/haskell/primitive";
    description = "Primitive memory-related operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
