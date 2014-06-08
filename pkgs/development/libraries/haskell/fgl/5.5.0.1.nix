{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "fgl";
  version = "5.5.0.1";
  sha256 = "0qw70f5hfrxmrx49wx8vk2f5cam7jbpb20mp4i0ybcwdld5ncqda";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://web.engr.oregonstate.edu/~erwig/fgl/haskell";
    description = "Martin Erwig's Functional Graph Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
