{ cabal }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.2.0.0";
  sha256 = "1gk0nx6bw5j9gxaa6ki70wqszbllz7c1ccfnwg49fl3qfabg1i7c";
  meta = {
    description = "Combinator library for splitting lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
