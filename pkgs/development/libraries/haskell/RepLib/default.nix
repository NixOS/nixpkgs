{ cabal, mtl, typeEquality }:

cabal.mkDerivation (self: {
  pname = "RepLib";
  version = "0.5.2.1";
  sha256 = "133zpiszfdb8s4hqd1xpgsiac98v04dclk3hivzxcg0h77m7qpcc";
  buildDepends = [ mtl typeEquality ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic programming library with representation types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
