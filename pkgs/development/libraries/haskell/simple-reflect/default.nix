{ cabal }:

cabal.mkDerivation (self: {
  pname = "simple-reflect";
  version = "0.3.1";
  sha256 = "189pc7fk28bwl0mq6hw502kc048n203rb4vpf2wva490r36xiw6s";
  meta = {
    homepage = "http://twan.home.fmf.nl/blog/haskell/simple-reflection-of-expressions.details";
    description = "Simple reflection of expressions containing variables";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
