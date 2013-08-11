{ cabal, byteable }:

cabal.mkDerivation (self: {
  pname = "securemem";
  version = "0.1.2";
  sha256 = "1szb530jw7666cnrfa8988p2b5scl2bfafi8kgslf7xi5yv7grqh";
  buildDepends = [ byteable ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-securemem";
    description = "abstraction to an auto scrubbing and const time eq, memory chunk";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
