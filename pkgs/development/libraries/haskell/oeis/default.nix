{ cabal, HTTP, network }:

cabal.mkDerivation (self: {
  pname = "oeis";
  version = "0.3.1";
  sha256 = "0kxs25b1z0b807vhrn8v7chsdsw8civqiym8767fy2rk5si0i4w2";
  buildDepends = [ HTTP network ];
  meta = {
    description = "Interface to the Online Encyclopedia of Integer Sequences";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
