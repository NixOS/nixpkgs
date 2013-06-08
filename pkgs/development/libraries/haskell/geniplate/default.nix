{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "geniplate";
  version = "0.6.0.3";
  sha256 = "1n73p57gkn9qf7jn54izypc7zycd9i6y9z9i1gc8yn1wd8sv7vkn";
  buildDepends = [ mtl ];
  meta = {
    description = "Use template Haskell to generate Uniplate-like functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
