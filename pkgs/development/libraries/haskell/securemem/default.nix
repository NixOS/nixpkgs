{ cabal, byteable }:

cabal.mkDerivation (self: {
  pname = "securemem";
  version = "0.1.3";
  sha256 = "1kycpk73vh8wwxzn35hmv36vwsc9r4g53f2fy6bn21q9gfm2r90j";
  buildDepends = [ byteable ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-securemem";
    description = "abstraction to an auto scrubbing and const time eq, memory chunk";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
